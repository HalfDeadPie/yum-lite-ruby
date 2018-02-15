# Encapsulate all the main functionality and represents the client
# using the user database and Yummly API
class Client
  # Provides the recipe for the logged user according
  # to his level and searching parameters
  #
  # @param parameters [Hash] searching parameters from from the command line
  def recipe(parameters)
    user = User.new
    user.read_creddentials
    user.login
    generated_food = YumConnector.search parameters, user.xp
    abort("Sorry, I can't find food for you like that") if generated_food.nil?
    user.update_last_food_id generated_food.id
    puts generated_food.to_str
  end

  # Register the user using Backendless
  #
  # @param email [String] email of the user
  # @param password [String] password of the user
  def register(email, password)
    user = User.new
    puts user.register email, password
  end

  # Login the user using Backendless
  #
  # @param email [String] email of the user
  # @param password [String] password of the user
  def login(email, password)
    user = User.new
    puts user.login email, password
  end

  # Provides the last recipe of logged user
  def last
    user = User.new
    user.read_creddentials
    user.login
    last_food = YumConnector.food_by_id user.last
    puts last_food.to_str
  end

  # Reviews the cooked food of the last recipe of logged user
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

  # Provides the stats of the user
  def user
    user = User.new
    user.read_creddentials
    user.login
    puts user.to_str
  end
end
