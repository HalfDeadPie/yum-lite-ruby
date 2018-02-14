# Handle requests using the Faraday adapter
class Request
  @uri = 'http://api.yummly.com/v1/api/'
  @app_id = 'a9ceda48'
  @app_key = '33bc48b7d177e55baeef2c4a7baa1ea8'
  @max_results = 3

  def self.generic_connection
    conn = Faraday.new(url: @uri)
    conn.headers['X-Yummly-App-ID'] = @app_id
    conn.headers['X-Yummly-App-Key'] = @app_key
    conn
  end

  # ----------------------------------------------------------------------------

  def self.search(parameters = {}, xp = 0)
    # build generic connection
    conn = generic_connection

    # set the search parameters
    search_parameters = {}

    # add phrase if exists
    add_phrase parameters, search_parameters

    # add other search parameters
    add_search_parameters parameters, search_parameters

    # add max searching results
    add_max_results search_parameters

    # calculate max cooking time according to the user's XP
    add_max_time search_parameters, xp

    # execute the request to /recipes with search parameters
    response = conn.get 'recipes', search_parameters

    # return body if OK response
    validate_response response
  end

  def self.get_recipe(food_id)
    # build generic connection
    conn = generic_connection

    # get food by its ID on yummly
    response = conn.get "recipe/#{food_id}"

    # return body if OK response
    validate_response response
  end

  def self.validate_response(response)
    response.body if response.status.eql? 200
  end
  # ----------------------------------------------------------------------------

  def self.add_max_results(parameters)
    parameters['maxResult'] = @max_results
  end

  def self.add_search_parameters(parameters, search_parameters)
    parameters.each do |key, value|
      metadata = get_metadata key
      metadata_json = Parser.jsonp_to_json metadata, key
      init_search_parameters search_parameters, key
      multiple_parameters = value.split(',')
      multiple_parameters.each do |single_parameter|
        search_value = Parser.get_search_value metadata_json, single_parameter
        build_search_parameters search_parameters, key, search_value
      end
    end
  end

  def self.add_phrase(parameters, search_parameters)
    hash_phrase = {}
    hash_phrase[:q] = parameters[:q] if parameters[:q]
    parameters.delete :q
    init_search_parameters search_parameters, :q
    build_search_parameters search_parameters, :q, hash_phrase.values.first
  end

  def self.get_metadata(key)
    metadata_key = Parser.slice_metadata_key key
    conn = generic_connection
    meta_response = conn.get "metadata/#{metadata_key}"
    meta_response.body
  end

  def self.init_search_parameters(search_parameters, key)
    search_parameters[key] = []
  end

  def self.build_search_parameters(search_parameters, key, search_value)
    search_parameters[key].push search_value
  end

  def self.add_max_time(parameters, xp)
    parameter = xp * @max_results * 10
    parameter = 80 if (xp * @max_results).eql? 0
    parameters['maxTotalTimeInSeconds'] = parameter
  end
end
