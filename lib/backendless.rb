# Provides communication with Backendless API
class Backendless
  @app_id = 'B04D050F-9131-884B-FFBE-F3A2EC48B300'
  @app_key = ENV['BACKENDLESS_KEY']
  @uri = "https://api.backendless.com/#{@app_id}/#{@app_key}/"

  def self.generic_connection
    conn = Faraday.new(url: @uri)
    conn.headers['Content-Type'] = 'application/json'
    conn.headers['application-type'] = 'REST'
    conn
  end

  def self.register(email, password)
    conn = generic_connection
    body = build_registration_body email, password
    response = conn.post 'users/register', body.to_json
    process_response response
  end

  def self.login(email, password)
    conn = generic_connection
    body = build_login_body email, password
    response = conn.post 'users/login', body.to_json
    process_response response
  end

  def self.process_response response
    if response.status.equal? 200
      response.body
    elsif [409, 400, 401].include? response.status
      nil
    else
      abort('I can not communicate with the user data. Set the BACKENDLESS_KEY')
    end
  end

  def self.build_registration_body(email, password)
    body = {
      email: email,
      password: password
    }
    body
  end

  def self.build_login_body(login, password)
    body = {
      login: login,
      password: password
    }
    body
  end

  def self.last(user_object_id)
    conn = generic_connection
    response = conn.get "users/#{user_object_id}"
    Parser.extract_food_id response.body
  end

  def self.update(object_id, user_token, key, value)
    conn = generic_connection
    conn.headers['user-token'] = user_token
    body = {}
    body[key] = value
    response = conn.put "data/users/#{object_id}", body.to_json
    process_response response
  end
end
