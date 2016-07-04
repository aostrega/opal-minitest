require 'minitest'
require 'source_map'

module Opal
  module Minitest
    class SourceMapBacktraceFilter < ::Minitest::BacktraceFilter
      def initialize(sourcemap)
        @sourcemap = sourcemap
      end

      def mapping(source, line, column)
        map = @sourcemap[source]
        if map
          SourceMap::Map.from_json(map).bsearch(SourceMap::Offset.new(line.to_i, column.to_i))
        end
      end

      def map_frame(source, line, column)
        mapping = mapping(source, line, column)
        if mapping
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
