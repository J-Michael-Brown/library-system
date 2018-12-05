require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')
require('./lib/list')
require('./lib/task')
require('pry')
require('pg')

DB = PG.connect({:dbname => "to_do"})
