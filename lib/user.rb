# Represents the user of this application
class User
  attr_reader :email, :password, :token, :xp

  def self.initialize
    @email = nil
    @password = nil
  end

  def register(email, password)
    response = Backendless.register email, password
    if response
      'Registration sucessful'
    else
      'Registration failed'
    end
  end

  def login(email = @email, password = @password)
    response = Backendless.login email, password
    if response
      process_login_response email, password, response
      store_creddentials
      'Login sucess'
    else
      'Login failed'
    end
  end

  def process_login_response(email, password, response)
    @email = email
    @password = password
    @token = Parser.extract_user_token response
    @id = Parser.login_object_id response
    @xp = Parser.extract_xp response
  end

  def last
    login_response = Backendless.login @email, @password
    object_id = Parser.login_object_id login_response
    Backendless.last(object_id)
  end

  def store_creddentials
    CSV.open('creddentials.csv', 'w') do |csv|
      csv << [@email, @password]
    end
    read_creddentials
  end

  def read_creddentials
    creddentials = []
    CSV.foreach 'creddentials.csv' do |record|
      creddentials << record
    end
    @email = creddentials[0][0]
    @password = creddentials[0][1]
  end

  def update_last_food_id(food_id)
    response = Backendless.update(@id, @token, 'food_id', food_id)
    true if response
  end

  def review(rating)
    real_rating = Integer(rating)
    real_rating = 3 if real_rating > 3
    real_rating = 0 if real_rating < 0
    @xp += real_rating
    last_food = Backendless.last @id
    return false if last_food.eql? 'Empty plate'
    response = Backendless.update(@id, @token, 'xp', @xp)
    update_last_food_id 'Empty plate' if response
    true if response
  end

  def to_str
    result = "Email: #{@email}\n"
    lvl = level xp
    result += "Level: #{lvl}\n"
    result += "XP: #{@xp}\n"
    result
  end

  def level(xp)
    xp / 10
  end
end
