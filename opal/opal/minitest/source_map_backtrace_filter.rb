# -*- coding: utf-8 -*-
require 'minitest'
require 'source_map'

module Opal
  module Minitest
    class SourceMapBacktraceFilter < ::Minitest::BacktraceFilter
      def initialize(sourcemap)
        @sourcemap = sourcemap.map { |source, map| [source, SourceMap::Map.from_json(map)] }.to_h
      end

      def mapping(source, line, column)
        map = @sourcemap[source]
        if map
          map.bsearch(SourceMap::Offset.new(line.to_i, column.to_i))
        end
      end

      def map_frame(method, source, line, column)
        mapping = mapping(source, line, column)
        if mapping
          source = mapping.source.sub(%r{^/__OPAL_SOURCE_MAPS__/|/}, '')
          line = mapping.original.line
          column = mapping.original.column
        else
          source =~ %r{^http://localhost:\d+/assets/(.*)\.self([^\?]*)}
          source = "#{$1}#{$2}"
        end
        frame = "#{source}:#{line}:#{column}"
        #                                   This is a special utf8 char ---v
        frame += ":in `#{method[1..-1]}'" if method && method.start_with?('ː')
        frame
      end

      def filter bt
        super.map do |frame|
          frame =~ /^(?:(.*)@)?(.*):(\d+):(\d+)$/
          map_frame($1, $2, $3, $4)
        end
      end
    end
  end
end
