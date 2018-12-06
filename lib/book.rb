require('psql_methods')

class Book
  attr_reader :title, :author_ids, :id
  def initialize(attributes)
    @title = attributes.fetch(:title)
    @author_ids = attributes.fetch(:author_ids)
    if attributes.include?(:id)
      @id = (attributes.fetch(:id).to_i)
    else
      @id = nil
    end
  end

  def save
    result = DB.exec("INSERT INTO books (title, author_ids) VALUES ('#{@title}', '#{int_array_to_psql(@author_ids)}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def delete!()
    DB.exec("DELETE FROM books WHERE id = #{self.id}")
    DB.exec("DELETE FROM checkouts WHERE book_id = #{self.id}")
    new_books = Book.all
  end

  def self.all
    returned_books = DB.exec("SELECT * FROM books;")
    books = []
    returned_books.each() do |book|
      title = book.fetch("title")
      id = book.fetch("id").to_i()
      author_ids = convert_sql_int_array(book.fetch("author_ids"))
      books.push(Book.new({:title => title, :id => id, :author_ids => author_ids}))
    end
    books
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM books WHERE id = #{id};")
    output_book = Book.new({
      :author_ids => convert_sql_int_array(result.first.fetch("author_ids")),
      :title => result.first.fetch("title"),
      :id => result.first.fetch("id").to_i
      })
  end

  def ==(another_book)
    self.author_ids().==(another_book.author_ids()).&(self.id().==(another_book.id())).&(self.title().==(another_book.title()))
  end
end
