# Handles connection using Requests and provides the results to client
class YumConnector
  # Searches the food according to search parameters from command line
  #
  # @param parameters [Hash] parameters from the command line
  # @param xp [Integer] the XP points of the user
  # @return [Food] new food randomly chosen from searched results
  def self.search(parameters, xp)
    result = Request.search parameters, xp
    return nil if result.nil?
    searched_result = JSON.parse result
    id = Parser.food_id searched_result['matches'].sample
    food_json = JSON.parse Request.get_recipe id
    Food.new food_json
  end

  # Provides the food from Yummly by its id
  #
  # @param food_id [String] the id of the food on Yummly
  # @return [Food] the food recipe from Yummly
  def self.food_by_id(food_id)
    return food_id if food_id.eql? 'Empty plate'
    food_json = JSON.parse Request.get_recipe food_id
    Food.new food_json
  end
end
