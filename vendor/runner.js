// Headlessly open test loader and wait until tests finish.

var url = phantom.args[0],
    page = require('webpage').create();

page.onConsoleMessage = function(msg) { console.log(msg) };

page.open(url, function(loadStatus) {
  if (loadStatus !== 'success') {
    console.error("Cannot load: " + url);
    phantom.exit(1);
  }
  var loop = setInterval(function() {
    var exitStatus = page.evaluate(function() {
      return window.OPAL_TEST_EXIT_STATUS;
    });

    if (exitStatus != null) {
      clearInterval(loop);
      phantom.exit(result);
    }
  }, 500);
});
