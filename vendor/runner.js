// Headlessly open test loader and run the tests.

var system = require('system');
var webpage = require('webpage');

var url = system.args[1];
var page = webpage.create();
var sourcemap = {};

page.onConsoleMessage = function(msg) { system.stdout.write(msg) };

page.onResourceReceived = function (response) {
  if (response.stage === "end") {
    response.headers.forEach(function (header) {
      if (header.name === "X-Sourcemap") {
        var original = page.evaluate(function (url, path) {
          var a = document.createElement('a');
          a.href = url;
          a.pathname = path;
          a.search = '';
          return a.href;
        }, response.url, header.value);
        sourcemap[response.url] = original;
      }
    });
  }
};

var loadSourcemap = function (i, done) {
  var sources = Object.keys(sourcemap);
  if (i < sources.length) {
    var source = sources[i];
    var url = sourcemap[source];
    var page = webpage.create();
    page.open(url, function (loadStatus) {
      sourcemap[source] = page.plainText;
      page.close();
      loadSourcemap(i+1, done);
    });
  } else {
    done();
  }
};

page.open(url, function(loadStatus) {
  if (loadStatus !== 'success') {
    console.error("Cannot load: " + url);
    phantom.exit(1);
  }
  loadSourcemap(0, function () {
    var exitStatus = page.evaluate(function (sourcemap) {
      return Opal.Object.$run_minitest(Opal.hash(sourcemap));
    }, sourcemap);
    phantom.exit(exitStatus);
  });
});
