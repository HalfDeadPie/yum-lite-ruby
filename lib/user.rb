# Represents the user of this application
class User
  # has email, password, token and xp points during the runtime
  attr_reader :email, :password, :token, :xp

  # Constructor creates the new user with unset email and password
  def self.initialize
    @email = nil
    @password = nil
  end

  # Register the user using Backendless
  #
  # @param email [String] email of the user
  # @param password [String] password of the user
  # @return [String] state of the registration in human-readable form
  def register(email, password)
    response = Backendless.register email, password
    if response
      'Registration sucessful'
    else
      'Registration failed'
    end
  end

  # Login the user using Backendless
  #
  # @param email [String] email of the user
  # @param password [String] password of the user
  # @return [String] state of the login in human-readable form
  def login(email = @email, password = @password)
    response = Backendless.login email, password
    if response
      process_login_response email, password, response
      store_creddentials
      'Login success'
    else
      abort('Login failed')
    end
  end

  # Process the login response and set the attributes of user
  #
  # @param email [String] email of the user
  # @param password [String] password of the user
  # @param response [JSON] response from login to Backendless
  def process_login_response(email, password, response)
    @email = email
    @password = password
    @token = Parser.extract_user_token response
    @id = Parser.login_object_id response
    @xp = Parser.extract_xp response
  end

  # Provides the last recipe of user
  #
  # @return [String] the last food id of the user
  def last
    login_response = Backendless.login @email, @password
    object_id = Parser.login_object_id login_response
    Backendless.last(object_id)
  end

  # Stores the credentials to 'creddentials.csv' to achieve persistence
  def store_creddentials
    CSV.open(ENV['HOME'] + '/creddentials.csv', 'w') do |csv|
      csv << [@email, @password]
    end
    read_creddentials
  end

  # Reads the credentials from the 'creddentials.csv' and set them
  def read_creddentials
    creddentials = []
    CSV.foreach ENV['HOME'] + '/creddentials.csv' do |record|
      creddentials << record
    end
    @email = creddentials[0][0]
    @password = creddentials[0][1]
  rescue StandardError => e
    abort("You are not logged in!\nERROR:\n#{e}")
  end

  # Updates the last food id in Backendless database
  #
  # @param food_id [String] the id of food from Yummly
  # @return [true, nil] the state of the operation
  def update_last_food_id(food_id)
    response = Backendless.update(@id, @token, 'food_id', food_id)
    true if response
  end

  # Reviews the last food of the user
  #
  # @param rating [String] the rating of the last food from 0 to 3
  # @return [true, nil] the status of the operation
  def review(rating)
    real_rating = check_rating rating
    @xp += real_rating
    last_food = Backendless.last @id
    return false if last_food.eql? 'Empty plate'
    response = Backendless.update(@id, @token, 'xp', @xp)
    update_last_food_id 'Empty plate' if response
    true if response
  end

  # Checks the boundary on food rating
  #
  # @param rating [String] rating of food
  # @return [String] real rating in proper interval
  def check_rating(rating)
    abort('Rating points missing!') if rating.nil?
    real_rating = Integer(rating)
    real_rating = 3 if real_rating > 3
    real_rating = 0 if real_rating < 0
    real_rating
  end

  # Provides the user stats in human-readable form
  #
  # @return [String] user stats
  def to_str
    result = "Email: #{@email}\n"
    lvl = level xp
    result += "Level: #{lvl}\n"
    result += "XP: #{@xp}\n"
    result
  end

  # Computes the level from XP
  #
  # @param xp [Integer] XP points of the user gained from ratings of his food
  # @return [String] level of the user
  def level(xp)
    xp / 10
  end
end
