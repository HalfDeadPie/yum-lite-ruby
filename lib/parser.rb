# Provides parsing methods of all kind
class Parser
  def self.get_search_value(json, description)
    json.each do |metapar|
      ext_hash = metapar.select { |k, _| k.downcase.include? 'description' }
      extern = ext_hash.values.first.downcase
      local = description.downcase
      return metapar['searchValue'] if "\b#{local}\b".match(extern)
    end
  end

  def self.jsonp_to_json(jsonp, key)
    metadata_key = slice_metadata_key key
    first_split = jsonp.split("set_metadata('#{metadata_key}', ")[1]
    second_split = first_split.split(');')[0]
    JSON.parse second_split
  end

  def self.food_id(food_json)
    abort("Sorry, I can't find food for you like that :(") if food_json.nil?
    id = food_json['id']
    id
  end

  def self.slice_metadata_key(key)
    metadata_key = key.to_s
    metadata_key.slice!('allowed') if metadata_key.include? 'allowed'
    metadata_key.slice!('excluded') if metadata_key.include? 'exclude'
    metadata_key.downcase
  end

  def self.login_object_id(login_response)
    j = JSON.parse login_response
    j['objectId']
  end

  def self.extract_food_id(response)
    j = JSON.parse response
    j['food_id']
  end

  def self.extract_user_token(response)
    j = JSON.parse response
    j['user-token']
  end

  def self.extract_xp(response)
    j = JSON.parse response
    j['xp']
  end
end
