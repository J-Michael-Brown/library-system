require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')
require('./lib/book')
require('./lib/patron')
require('./lib/checkout')
require('./lib/author')
require('./lib/psql_methods')
require('pry')
require('pg')

DB = PG.connect({:dbname => "library_system"})

get ('/') do
  erb(:index)
end

get('/shelf') do
  @books = Book.all
  erb(:shelf)
end

get ('/shelf/book/:book_id') do
  book_id = params[:book_id].to_i
  @book = Book.find(book_id)
  erb(:book)
end

get ('/admin') do
  @books = Book.all
  @authors = Author.all
  erb(:admin)
end

get ('/admin/book_database') do
  @books = Book.all
  erb(:book_database)
end

patch ('/admin/book_database') do
  title = params.fetch("title")
  author = params.fetch("author")
  @new_book = Book.new({
    :author => author,
    :title => title
  })
  @new_book.save
  @books = Book.all
  erb(:book_database)
end

get ('/admin/book_database/book/:book_id') do
  book_id = params[:book_id].to_i
  @book = Book.find(book_id)
  @books = Book.all
  erb(:book)
end
