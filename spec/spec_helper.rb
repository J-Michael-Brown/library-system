require("rspec")
require("pg")
require("book")
require("patron")
require("checkout")
require("author")
require("psql_methods")
require("pry")

DB = PG.connect({:dbname => "library_system_test"})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM patrons *;")
    DB.exec("DELETE FROM authors *")
    DB.exec("DELETE FROM checkouts *;")
  end
end

def prime_book(title)
  book = Book.new({:title => title, :author_ids => [0]})
  book.save()
  book
end

def prime_author(first_name, last_name)
  author = Author.new({
    :first_name => first_name,
    :last_name => last_name
  })
  author.save
  author
end
