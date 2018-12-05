class Book
  attr_reader :title, :author, :id
  def initialize(attributes)
    @title = attributes.fetch(:title)
    @author = attributes.fetch(:author)
    if attributes.include?(:id)
      @id = (attributes.fetch(:id).to_i)
    else
      @id = nil
    end
  end

  def save
    result = DB.exec("INSERT INTO books (title, author) VALUES ('#{@title}', '#{@author}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def delete!()
    DB.exec("DELETE FROM books WHERE id = #{self.id}")
    DB.exec("DELETE FROM checkouts WHERE book_id = #{self.id}")
    new_book = Book.all
    if new_book.include?(self)
      return 'deleted'
    else
      return 'didn\'t work'
    end
  end

  def self.all
    returned_books = DB.exec("SELECT * FROM books;")
    books = []
    returned_books.each() do |book|
      title = book.fetch("title")
      id = book.fetch("id").to_i()
      author = book.fetch("author")
      books.push(Book.new({:title => title, :id => id, :author => author}))
    end
    books
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM books WHERE id = #{id};")
    output_book = Book.new({
      :author => result.first.fetch("author"),
      :title => result.first.fetch("title"),
      :id => result.first.fetch("id").to_i
      })
  end

  def ==(another_book)
    self.author().==(another_book.author()).&(self.id().==(another_book.id())).&(self.title().==(another_book.title()))
  end
end
