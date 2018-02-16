# Manages Yummly requests using the Faraday adapter
class Request
  # Yummly URI
  @uri = 'http://api.yummly.com/v1/api/'

  # application ID should not be changed
  @app_id = 'a9ceda48'

  # application KEY from the ENV variable
  @app_key = ENV['YUMMLY_KEY']

  # the maximum searched results
  @max_results = 3

  # Creates the generic connection for Yummly API
  #
  # @return [Faraday connection] connection to Yummly with mandatory headers
  def self.generic_connection
    conn = Faraday.new(url: @uri)
    conn.headers['X-Yummly-App-ID'] = @app_id
    conn.headers['X-Yummly-App-Key'] = @app_key
    conn
  end

  # ----------------------------------------------------------------------------
  # Search the recipes filtrated with parameters
  #
  # @param parameters [Hash] searching parameters from command line
  # @param xp [Integer] XP points of user for setting max cooking time
  # @return [String] Response body containing founded recipes
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
    process_response response
  end

  # Provides recipe by ID
  #
  # @param food_id [String] recipe id of food on Yummly
  # @return [String] response body containing the recipe data
  def self.get_recipe(food_id)
    # build generic connection
    conn = generic_connection

    # get food by its ID on yummly
    response = conn.get "recipe/#{food_id}"

    # return body if OK response
    process_response response
  end

  # Processes response of all kind from Yummly
  #
  # @param response [Faraday response] response from Yummly
  # @return [String] body of response
  def self.process_response(response)
    if response.status.eql? 200
      response.body
    elsif [414].include? response.status
      abort('Sorry, I can not find food like this')
    else
      abort('I can not communicate with Yummly. Set the YUMMLY_KEY')
    end
  end

  # Add max results parameter to searching parameters
  #
  # @param parameters [Hash] searching parameters
  def self.add_max_results(parameters)
    parameters['maxResult'] = @max_results
  end

  # Add parameters from command line to searching parameters
  #
  # @param parameters [Hash] parameters from command line
  # @param search_parameters [Hash] search parameters in proper form for request
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

  # Add phrase to searching parameters
  #
  # @param parameters [Hash] parameters from command line
  # @param search_parameters [Hash] search parameters in proper form for request
  def self.add_phrase(parameters, search_parameters)
    hash_phrase = {}
    hash_phrase[:q] = parameters[:q] if parameters[:q]
    parameters.delete :q
    init_search_parameters search_parameters, :q
    build_search_parameters search_parameters, :q, hash_phrase.values.first
  end

  # Provides metadata by key
  #
  # @param key [String] key of metadata
  # @return [String] response body of metadata
  def self.get_metadata(key)
    metadata_key = Parser.slice_metadata_key key
    conn = generic_connection
    meta_response = conn.get "metadata/#{metadata_key}"
    process_response meta_response
  end

  # Initialize the search parameters array in hash on key position
  #
  # @param search_parameters [Hash] search parameters for request
  # @param key [String] key of metadata
  def self.init_search_parameters(search_parameters, key)
    search_parameters[key] = []
  end

  # Build the array in hash on key position
  #
  # @param search_parameters [Hash] search parameters for request
  # @param key [String] key from metadata
  # @param search_value [String] value from metadata for searching
  def self.build_search_parameters(search_parameters, key, search_value)
    search_parameters[key].push search_value
  end

  # Add maximal time for cooking computed from XP points of user
  #
  # @param parameters [Hash] search parameters for request
  # @param xp [String] XP points of the user
  def self.add_max_time(parameters, xp)
    parameter = xp * @max_results * 10
    parameter = 80 if (xp * @max_results).eql? 0
    parameters['maxTotalTimeInSeconds'] = parameter
  end
end
