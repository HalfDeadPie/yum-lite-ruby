require 'yum_connector'
require 'cli_parser'
require 'food'
require 'backendless'
require 'user'

# Provides methods to access Yummly API
class Client
  def recipe(parameters)
    user = User.new
    user.read_creddentials
    user.login
    generated_food = YumConnector.search parameters, user.xp
    abort("Sorry, I can't find food for you like that") if generated_food.nil?
    user.update_last_food_id generated_food.id
    puts generated_food.to_str
  end

  def register(email, password)
    user = User.new
    puts user.register email, password
  end

  def login(email, password)
    user = User.new
    puts user.login email, password
  end

  def last
    user = User.new
    user.read_creddentials
    user.login
    last_food = YumConnector.food_by_id user.last
    puts last_food.to_str
  end

  def review(rating)
    user = User.new
    user.read_creddentials
    user.login
    response = user.review rating
    if response
      puts 'Last food reviewed!'
    else
      puts 'Nothing to review'
    end
  end

  def user
    user = User.new
    user.read_creddentials
    user.login
    puts user.to_str
  end
end
