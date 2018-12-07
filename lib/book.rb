
class Book
  attr_reader :title, :author_ids, :id
  def initialize(attributes)
    @title = attributes.fetch(:title)
    @author_ids = attributes.fetch(:author_ids, [])
    @id = attributes.fetch(:id, nil)
    if @id.class == String
      @id = @id.to_i
    end
  end

  def save
    result = DB.exec("INSERT INTO books (title, author_ids) VALUES ('#{@title}', '#{int_array_to_psql(@author_ids)}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
    @author_ids.each do |author_id|
      author = Author.find(author_id)
      new_book_ids = author.book_ids+[@id]
      DB.exec("UPDATE authors SET book_ids = '#{int_array_to_psql(new_book_ids)}' WHERE id = #{author_id};")
    end
    @id
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
      :author_ids => convert_sql_int_array(result.first.fetch("author_ids", [])),
      :title => result.first.fetch("title"),
      :id => result.first.fetch("id").to_i
      })
  end

  def clear_authors
    @author_ids.each do |author_id|
      author = Author.find(author_id)
      new_book_ids = author.book_ids-[@id]
      DB.exec("UPDATE authors SET book_ids = '#{int_array_to_psql(new_book_ids)}' WHERE id = #{author_id};")
    end
    DB.exec("UPDATE books SET author_ids = '{}' WHERE id = #{@id};")
    new_self = Book.find(@id)
    @author_ids = new_self.author_ids
  end

  def find_author_names
    author_names = []
    @author_ids.each do |author_id|
      new_array = []
      author = Author.find(author_id)
      first_name = author.first_name
      last_name = author.last_name
      new_array.push(last_name)
      new_array.push(first_name)
      author_names.push(new_array)
    end
    author_names
  end

  def ==(another_book)
    self.author_ids().==(another_book.author_ids()).&(self.id().==(another_book.id())).&(self.title().==(another_book.title()))
  end
end
