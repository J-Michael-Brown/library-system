require("psql_methods")

class Author

  attr_reader :last_name, :first_name, :book_ids, :id

  def initialize(attributes)
    @last_name = attributes.fetch(:last_name)
    @first_name = attributes.fetch(:first_name)
    # if attributes.include?(:book_ids)
      @book_ids = attributes.fetch(:book_ids, [])
    # else
      # @book_ids = []
    # end
    if attributes.include?(:id)
      @id = attributes.fetch(:id)
    else
      @id = nil
    end
  end

  def save
    result = DB.exec("INSERT INTO authors (first_name, last_name, book_ids) VALUES ('#{@first_name}', '#{@last_name}', '#{int_array_to_psql(@book_ids)}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def delete!()
    DB.exec("DELETE FROM authors WHERE id = #{self.id}")
    new_authors = Author.all
  end

  def self.all
    returned_authors = DB.exec("SELECT * FROM authors;")
    authors = []
    returned_authors.each() do |author|
      first_name = author.fetch("first_name")
      id = author.fetch("id").to_i()
      book_ids = convert_sql_int_array(author.fetch("book_ids"))
      last_name = author.fetch("last_name")
      authors.push(Author.new({
        :first_name => first_name,
        :id => id,
        :book_ids => book_ids,
        :last_name => last_name
      }))
    end
    authors
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM authors WHERE id = #{id};")
    output_author = Author.new({
      :book_ids => convert_sql_int_array(result.first.fetch("book_ids")),
      :first_name => result.first.fetch("first_name"),
      :id => result.first.fetch("id").to_i,
      :last_name => result.first.fetch("last_name")
      })
  end

  def ==(another_author)
    self.book_ids().==(another_author.book_ids()).&(self.id().==(another_author.id())).&(self.first_name().==(another_author.first_name())).&(self.last_name.==(another_author.last_name))
  end
end
