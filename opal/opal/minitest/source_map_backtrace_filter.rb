require 'minitest'
require 'source_map'

module Opal
  module Minitest
    class SourceMapBacktraceFilter < ::Minitest::BacktraceFilter
      def initialize(sourcemap)
        @sourcemap = sourcemap
      end

      def map_frame(source, line, column)
        map = @sourcemap[source]
        if map
          map = SourceMap::Map.from_json(map)
          mapping = map.bsearch(SourceMap::Offset.new(line.to_i, column.to_i))
          source = mapping.source.sub(%r{^/__OPAL_SOURCE_MAPS__/|/}, '')
          line = mapping.original.line
          column = mapping.original.column
        else
          source =~ %r{^http://localhost:\d+/assets/(.*)\.self([^\?]*)}
          source = "#{$1}#{$2}"
        end
        "#{source}:#{line}:#{column}"
      end

      def filter bt
        super.map do |frame|
          frame =~ /^(?:.*@)?(.*):(\d+):(\d+)$/
          map_frame($1, $2, $3)
        end
      end
    end
  end
end
