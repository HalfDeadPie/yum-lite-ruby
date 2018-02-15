# The command line interface parser
class CliParser
  # Options of the command line parser
  @options = {}

  # help message
  @help = {
    holiday: 'Include/exclude holiday recipes',
    ing: 'Include/exclude recipes with ingredients',
    cui: 'Include/exclude recipes of national cuisines',
    diet: 'Include/exclude diet recipes',
    phrase: 'Includes recipes with phrase in name'
  }

  # building the banner
  @banner = "Usage: yum [options] SUBCOMMAND\n"
  @banner += "\nSUBCOMMANDS:\n"
  @banner += "\trecipe\t\t-\t\tGenerates recipe according to parameters\n\n"
  @banner += "\tregister USERNAME PASSWORD\t\t-\t\tRegister the new user\n\n"
  @banner += "\tlogin USERNAME PASSWORD\t\t-\t\tLogin the user\n\n"
  @banner += "\tlast\t\t-\t\tPrint the last generated food\n\n"
  @banner += "\treview REVIEW\t\t-\t\tUser reviews the last generated"
  @banner += "food from 0 to 3 points and gain the XP points\n\n"
  @banner += "\tuser\t\t-\t\tPrints the user stats\n\n"

  # Parse the options in command line
  def self.parse_opts
    OptionParser.new do |opts|
      opts.banner = @banner

      # help message option
      opts.on('--help',
              'Prints help message') do
        puts opts
        exit
      end

      # version message option
      opts.on('--version',
              'Prints version') do
        puts "yum #{Yum::VERSION}"
        exit
      end

      # phrase -----------------------------------------------------------------
      # include recipe with phrase
      opts.on('-p', '--phrase PHRASE', @help[:phrase]) do |phrase|
        @options[:q] = phrase
      end

      # holiday ----------------------------------------------------------------
      # include holiday recipes
      opts.on('-h', '--holiday HOLIDAY', @help[:holiday]) do |holiday|
        @options[:allowedHoliday] = holiday
      end

      # exclude holiday recipes
      opts.on('--eh', '--excluded-holiday HOLIDAY', @help[:holiday]) do |hol|
        @options[:excludedHoliday] = hol
      end

      # ingredients ------------------------------------------------------------
      # include ingredients in recipes
      opts.on('-i', '--ingredients INGREDIENT', @help[:ing]) do |ing|
        @options[:allowedIngredient] = ing
      end

      # exclude holiday in recipes
      opts.on('--ei', '--excluded-ingredient INGREDIENT', @help[:ing]) do |ing|
        @options[:excludedIngredient] = ing
      end

      # cuisines ---------------------------------------------------------------
      # include cuisines in recipes
      opts.on('-c', '--cuisine CUISINE', @help[:cui]) do |cui|
        @options[:allowedCuisine] = cui
      end

      # exclude cuisines in recipes
      opts.on('--ec', '--excluded-cuisine CUISINE', @help[:cui]) do |cui|
        @options[:excludedCuisine] = cui
      end
      # diets ------------------------------------------------------------------
      # include diets in recipes
      opts.on('-d', '--diet DIET', @help[:diet]) do |diet|
        @options[:allowedDiet] = diet
      end

      # exclude diets in recipes
      opts.on('--ed', '--excluded-diet DIET', @help[:diet]) do |diet|
        @options[:excludedDiet] = diet
      end
    end.parse!
  rescue OptionParser::InvalidOption => e
    abort(e)
  end

  # Parse the arguments in the command line
  def self.parse_argv
    client = Client.new
    subcommands = {
      recipe: -> { client.recipe @options },
      register: -> { client.register ARGV[1], ARGV[2] },
      login: -> { client.login ARGV[1], ARGV[2] },
      last: -> { client.last },
      review: -> { client.review ARGV[1] },
      user: -> { client.user }
    }
    call_subcommand subcommands[ARGV[0].to_sym]
  end

  # Tries to call subcommand extracted from hash
  #
  # @param command [String] subcommand to call
  def self.call_subcommand(command)
    if command.nil?
      abort(@banner)
    else
      command.call
    end
  end
end
