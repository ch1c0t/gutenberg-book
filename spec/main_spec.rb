require_relative './helper'
require 'fileutils'

include Gutenberg

class Minitest::Spec
  class << self
    def it_behaves_like_a_book book
      it 'returns metainfo' do
        metainfo = 
          {
            "Title"        => "Alice's Adventures in Wonderland",
            "Author"       => "Lewis Carroll",
            "Posting Date" => "June 25, 2008 [EBook #11] Release Date: March, 1994 [Last updated: December 20, 2011]",
            "Language"     => "English"
          }

        book.metainfo.must_equal metainfo
      end

      it 'returns paragraphs' do
        book.paragraphs.size.must_equal 820
      end

      it 'allows to access paragraphs by id' do
        paragraph = "'I shall do nothing of the sort,' said the Mouse, getting up and walking away. 'You insult me by talking such nonsense!'"
        book[100].must_equal paragraph
      end

      it 'provides enumerable' do
        book.each.to_a.must_equal book.paragraphs
      end

      it 'can be saved to a file' do
        file = "spec/data/#{book.__id__}.db"
        book.save_to file

        another_book = Book.new_from_db file
        book.metainfo.must_equal another_book.metainfo
      end
    end
  end
end

describe Book do
  describe 'it can be created from txt' do
    book = Book.new_from_txt 'spec/data/pg11.txt'
    it_behaves_like_a_book book
  end

  describe 'it can be created from db' do
    book = Book.new_from_db 'spec/data/pg11.db'
    it_behaves_like_a_book book
  end
end

MiniTest::Unit.after_tests do
  files = Dir['spec/data/[0-9]*.db']
  File.delete *files
end
