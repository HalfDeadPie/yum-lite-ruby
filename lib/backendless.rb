# Provides communication with Backendless API
# that is used to store data about the users
class Backendless
  # Backendless application ID - this shouldn't change
  @app_id = 'B04D050F-9131-884B-FFBE-F3A2EC48B300'

  # Backendless application KEY - this must be set as
  # the ENV variable 'BACKENDLESS_KEY'
  @app_key = ENV['BACKENDLESS_KEY']

  # URI to the Backendless including Application ID and KEY
  @uri = "https://api.backendless.com/#{@app_id}/#{@app_key}/"

  # Creates the generic connection to Backendless and add
  # mandatory headers
  #
  # @return [Faraday connection] generic connection
  def self.generic_connection
    conn = Faraday.new(url: @uri)
    conn.headers['Content-Type'] = 'application/json'
    conn.headers['application-type'] = 'REST'
    conn
  end

  # Register the user in the Backendless database
  # and provides response
  #
  # @param email [String] email of the user
  # @param password [String] password of the user
  # @return [String, nil] The response of registration
  def self.register(email, password)
    conn = generic_connection
    body = build_registration_body email, password
    response = conn.post 'users/register', body.to_json
    process_response response
  end

  # Login the user in the Backendless database
  # and provides the response
  #
  # @param email [String] email of the user
  # @param password [String] password of the user
  # @return [String, nil] The response of login
  def self.login(email, password)
    conn = generic_connection
    body = build_login_body email, password
    response = conn.post 'users/login', body.to_json
    process_response response
  end

  # Process the response of request according to status
  #
  # @param response [Faraday response] the response of request
  # @return [String, nil] The response body
  def self.process_response(response)
    if response.status.equal? 200
      response.body
    elsif [409, 400, 401].include? response.status
      nil
    else
      abort('I can not communicate with the user data. Set the BACKENDLESS_KEY')
    end
  end

  # Builds the body of registration request
  # with email and password
  #
  # @param email [String] email of the user
  # @param password [String] password of the user
  # @return [Hash] the body for registration
  def self.build_registration_body(email, password)
    body = {
      email: email,
      password: password
    }
    body
  end

  # Builds the body of login request
  # with email and password
  #
  # @param login [String] email of the user
  # @param password [String] password of the user
  # @return [Hash] the body for login
  def self.build_login_body(login, password)
    body = {
      login: login,
      password: password
    }
    body
  end

  # Provides the last food of user
  #
  # @param user_object_id [String] ObjectID of the user data
  # @return [String] The food id of last recipe
  def self.last(user_object_id)
    conn = generic_connection
    response = conn.get "users/#{user_object_id}"
    Parser.extract_food_id response.body
  end

  # Update the property in userdata
  #
  # @param object_id [String] the object ID of user data
  # @param user_token [String] token receved from login operation
  # @return [Faraday response, nil] The body of the response
  def self.update(object_id, user_token, key, value)
    conn = generic_connection
    conn.headers['user-token'] = user_token
    body = {}
    body[key] = value
    response = conn.put "data/users/#{object_id}", body.to_json
    process_response response
  end
end
