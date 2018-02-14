require 'request'
require 'json'

# Handles connection using Requests and provides the results to client
class YumConnector
  def self.search(parameters, xp)
    result = Request.search parameters, xp
    return nil if result.nil?
    searched_result = JSON.parse result
    id = Parser.food_id searched_result['matches'].sample
    food_json = JSON.parse Request.get_recipe id
    Food.new food_json
  end

  def self.food_by_id(food_id)
    return food_id if food_id.eql? 'Empty plate'
    food_json = JSON.parse Request.get_recipe food_id
    Food.new food_json
  end
end
