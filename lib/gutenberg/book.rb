require 'pathname'

require "gutenberg/book/version"

module Gutenberg
  class Book
    include Enumerable

    def each &b
      paragraphs.each &b
    end

    def initialize parts
      @book_start = parts.find_index { |s| s.start_with? '*** START' }
      @book_end   = parts.find_index { |s| s.start_with? '*** END' }
      @parts = parts
    end

    class << self
      def new_from_txt path
        file = Pathname.new(path).expand_path
        parts = IO.read(file)
          .split(/\r\n\r\n/)
          .delete_if(&:empty?)
          .map { |part| part.strip.gsub "\r\n", ' ' }

        new parts
      end

      def new_from_daybreak path
        new (Daybreak::DB.new path)
      end
    end

    def metainfo
      get_metainfo = -> do 
        metainfo = {}
        @parts[0..@book_start].each do |string|
          key, value = string.split ': ', 2
          metainfo[key] = value unless key.nil? || value.nil?
        end

        metainfo
      end

      @metainfo ||= get_metainfo[]
    end

    def paragraphs
      get_paragraphs = -> { @parts[@book_start+1...@book_end] }
      @paragraphs ||= get_paragraphs[]
    end

    def [] id
      paragraphs[id]
    end

    def save_to file
      db = Daybreak::DB.new file
      @parts.each { |k, v| db[k] = v }
      db.flush; db.close
    end
  end
end
