require 'pathname'

require "gutenberg/book/version"
require "gutenberg/book/paragraph"

module Gutenberg
  class Book
    def initialize path
      file = Pathname.new(path).expand_path
      @parts = IO.read(file)
        .split(/\r\n\r\n/)
        .delete_if(&:empty?)
        .map { |part| part.strip.gsub "\r\n", ' ' }

      @book_start = @parts.find_index { |s| s.start_with? '*** START' }
      @book_end   = @parts.find_index { |s| s.start_with? '*** END' }
    end

    def metainfo
      get_metainfo = -> do 
        @metainfo = {}
        @parts[0..@book_start].each do |string|
          key, value = string.split ': ', 2
          @metainfo[key] = value unless key.nil? || value.nil?
        end

        @metainfo
      end

      @metainfo || get_metainfo[]
    end

    def paragraphs
      get_paragraphs = -> do
        @paragraphs = @parts[@book_start+1...@book_end].map do |string|
          Paragraph.new string
        end
      end

      @paragraphs || get_paragraphs[]
    end
  end
end
