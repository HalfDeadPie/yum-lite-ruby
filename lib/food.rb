# Represents single food from Yummly
class Food
  attr_reader :id

  def initialize(food_json)
    @name = food_json['name']
    @id = food_json['id']
    @aprox_time = food_json['totalTime']
    @image_url = image_url food_json
    @ingredients = food_json['ingredientLines']
    @guide_url = food_json['source']['sourceRecipeUrl']
  end

  def image_url(food_json)
    food_json['images'][0].values.first
  end

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
