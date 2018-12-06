require("rspec")
require("pg")
require("book")
require("patron")
require("checkout")
require("author")
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
