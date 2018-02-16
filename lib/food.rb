# Represents single recipe from Yummly
class Food
  # the id of the recipe on Yummly
  attr_reader :id

  # Creates food with the parameters from JSON
  #
  # @param food_json [JSON] recipe encapsulated in json from Yummly
  def initialize(food_json)
    @name = food_json['name']
    @id = food_json['id']
    @aprox_time = food_json['totalTime']
    @image_url = image_url food_json
    @ingredients = food_json['ingredientLines']
    @guide_url = food_json['source']['sourceRecipeUrl']
  end

  # Extract image from json
  #
  # @param food_json [JSON] recipe encapsulated in json from Yummly
  # @return [String] URL of the image
  def image_url(food_json)
    url = food_json['images'][0]['hostedLargeUrl']
    url = 'Sorry, I can not provide you picture of this food' if url.nil?
    url
  end

  # Provides stats of the user in human-readble form
  #
  # @return [String] stats of the user
  def to_str
    result = @name
    result += "\nID: #{@id}"
    result += "\n\nApproximate time: #{@aprox_time}"
    result += "\nImage URL: #{@image_url}\n"
    result += "\nIngredients:\n"
    result += @ingredients.join("\n")
    result += "\n\nStep-by-step:  #{@guide_url}\n"
    result
  end
end
