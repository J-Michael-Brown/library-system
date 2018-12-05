require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')
require('./lib/book')
require('./lib/patron')
require('./lib/checkout')
require('pry')
require('pg')

DB = PG.connect({:dbname => "library_system"})

get ('/') do
  erb(:index)
end

get ('/admin') do
  erb(:admin)
end

get('/shelf') do
  @books = Book.all
  erb(:shelf)
end

get ('/shelf/book/:book_id') do
  @book = Book.find(params[:id].to_i)
  erb(:book)
end
