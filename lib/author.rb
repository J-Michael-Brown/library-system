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

  def book_ids_string
    string = []
    @book_ids.each do |book_id|
      string.push(book_id.to_s)
      string.push(',')
    end
    string.pop
    string.join
  end

  def save
    result = DB.exec("INSERT INTO authors (first_name, last_name, book_ids) VALUES ('#{@first_name}', '#{@last_name}', '{#{self.book_ids_string}}') RETURNING id;")
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
      book_ids = convert_sql_num_array(author.fetch("book_ids"))
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
      :book_ids => convert_sql_num_array(result.first.fetch("book_ids")),
      :first_name => result.first.fetch("first_name"),
      :id => result.first.fetch("id").to_i,
      :last_name => result.first.fetch("last_name")
      })
  end

  def ==(another_author)
    self.book_ids().==(another_author.book_ids()).&(self.id().==(another_author.id())).&(self.first_name().==(another_author.first_name())).&(self.last_name.==(another_author.last_name))
  end
end

def convert_sql_num_array(sql_str)
  sql_num_array = convert_sql_array(sql_str)
  nums = []

  sql_num_array.each do |num|
    # binding.pry
    if num != "{}"
      nums.push(num.to_i)
    end
  end
  nums
end

def convert_sql_array(sql_str) # input looks like "{1,2,3}" or "{'one','two','three'}"
  new_array = (sql_str.split('')-["{","}"]).join.split(',')
end

def convert_sql_str_array(sql_str)
  new_array = convert_sql_array(sql_str)
  output = []
  new_array.each do |item|
    partial = item.split('')[1..-1]
    partial.pop
    output.push(partial.join)
  end
  output
end
