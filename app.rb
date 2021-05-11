require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require "erb"
set :bind, '0.0.0.0'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

def store_recipe(filename, recipe_name, recipe_description)
  File.open(filename, "a+") do |file|
    file.puts("#{recipe_name}: #{recipe_description}")
  end
end

def read_recipes(filename)
  return [] unless File.exist?(filename)
  File.read(filename).split("\n")
end

def destroy_recipe(filename, index)
  filename.delete_at(index)
end
# <%= destroy_recipe('recipes.txt', index)%>


get '/' do
  @recipe_name = params["recipe_name"]
  @recipe_description = params["recipe_description"]
  @recipes = read_recipes('recipes.txt')
  erb :index
end

get '/new' do
  @recipe_name = params['recipe_name']
  @recipe_description = params['recipe_description']
  erb :new
end

post '/new' do
  @recipe_name = params['recipe_name']
  @recipe_description = params['recipe_description']
  store_recipe('recipes.txt', @recipe_name, @recipe_description)
  redirect "/?recipe_name=#{@recipe_name}&&recipe_description=#{@recipe_description}"
end

get '/destroy' do

end
