# Provides parsing methods of all kind
class Parser
  # Extract the search value from json according to the description
  #
  # @param json [JSON] metadata from Yummly API
  # @param description [String] local description of data
  # @return [String] search value from metadata for Yummly API
  def self.get_search_value(json, description)
    json.each do |metapar|
      ext_hash = metapar.select { |k, _| k.downcase.include? 'description' }
      extern = ext_hash.values.first.downcase
      local = description.downcase
      return metapar['searchValue'] if "\b#{local}\b".match(extern)
    end
  end

  # Parse the jsonp to json
  #
  # @param jsonp [String] jsonp format to parse
  # @param key [String] key used in slicing jsonp
  # @return [JSON] parsed json from jsonp
  def self.jsonp_to_json(jsonp, key)
    metadata_key = slice_metadata_key key
    first_split = jsonp.split("set_metadata('#{metadata_key}', ")[1]
    second_split = first_split.split(');')[0]
    JSON.parse second_split
  end

  # Extracts the food id from json
  #
  # @param food_json [JSON] the food json
  # @return [String] id of the food from json
  def self.food_id(food_json)
    abort("Sorry, I can't find food for you like that :(") if food_json.nil?
    id = food_json['id']
    id
  end

  # Extracts the metadata key from search parameter
  #
  # @param key [String] key to be sliced
  # @return [String] metadata key
  def self.slice_metadata_key(key)
    metadata_key = key.to_s
    metadata_key.slice!('allowed') if metadata_key.include? 'allowed'
    metadata_key.slice!('excluded') if metadata_key.include? 'exclude'
    metadata_key.downcase
  end

  # Extracts object ID from lofin response
  #
  # @param login_response [JSON] response from login
  # @return [Strng] object ID of the user data
  def self.login_object_id(login_response)
    j = JSON.parse login_response
    j['objectId']
  end

  # Extracts the food id from response
  #
  # @param response [String] response body containing the recipe
  # @return [String] food id from response
  def self.extract_food_id(response)
    j = JSON.parse response
    j['food_id']
  end

  # Extracts the user token from response
  #
  # @param response [String] response body containing user token after login
  # @return [String] user token generated when logged in
  def self.extract_user_token(response)
    j = JSON.parse response
    j['user-token']
  end

  # Extract value of XP points
  #
  # @param response [String] response bode containing the XP value
  # @return [String] XP points of the user
  def self.extract_xp(response)
    j = JSON.parse response
    j['xp']
  end
end
