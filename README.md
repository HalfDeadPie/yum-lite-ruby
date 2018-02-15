# Yum

The Yum is the application with command line interface. The main purpose of this application is to increase your cookings
skills, which are represented as the level. All you need to do is to generate the recipe which you like, cook the food, eat it
and review it using scale from 0 to 3. The better food you prepare, the more XP points you get. Increasing your XP points leads
to increasing your level. And your level and XP points "unlock" for you more difficult recipes, which needs more time too cook.

The application uses the Yummly API to access the recipes of the food:

    https://developer.yummly.com/
    
There is also used the Backendless REST as the storage of users data:

    https://backendless.com/docs/rest/doc.html
    
Application uses Faraday adapter for executing the requests:

    http://www.rubydoc.info/gems/faraday/Faraday/Adapter

As the new user, you should registrate first with your email and password. After login, you start at level 0 and you
are able to generate recipe. So let's cook!

## Installation

You are able to install this gem using this command:

    $ gem install yum
    
You can find it on link:

    https://rubygems.org/gems/yum

Or you can download it from Github and install it this way:

    $ gem build yum.gemspec
    $ gem install yum-[VERSION].gem
    
## Usage

All functionality of this command line application is provided trough the command ```yum```. Before using this
application, you must set two environment variables ```BACKENDLESS_KEY``` and ```YUMMLY_KEY```, which
are specific for this application.

_Because it is an academic application, you need to ask for the keys from author._

Registration:

    $ yum register EMAIL PASSWORD
    
Login:

    $ yum login EMAIL PASSWORD
    
Recipe may be generated only for the logged user, because its difficulty _(maximal time for cooking)_ is computed from user's level.
User is also able to set filter for searching in recipes _(holiday recipes, diet, natioanl cuisines, ingredients, phrase,...)_ 
The command that provides recipe looks like this:

    $ yum [OPTIONS] recipe
    
The user is able to view his last recipe

    $ yum last
    
Expected scenario how to play this _game_ is when user generaters the recipe, he cooks it after that. After all that
cooking and eating, user is able to review his prepared food from 0 to 3 points. The reviews provides XP points to user.
The user is able to review his last food only once. After that, his last food is deleted from the database.

    $ yum review [0..3]

To display the user's stats _(email, level, xp)_, you should use this command:

    $ yum user
    
## Documentation

To generate the documentation using the ```yard``` use the command

    $ yard doc
    
## Tests

To run the tests using the ```rspec``` set the ```BACKENDLESS_KEY``` and ```YUMMLY_KEY``` and use the command:

    $ rspec spec 
    
## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Tasks

- [x] generates recipes from https://www.yummly.com/ for user depending on user's level
- [x] after cooking the food, the user or user's friend is able to evaluate the food
- [x] the user gain XP depending on the evaluation of the cooked food
- [x] the user is able to filter diet
- [x] the user is able to filter national cuisine
- [x] the user is able to filter ingredients
- [x] the user is able to choose aprox. time for cooking - _time depends on user's level_
- [x] the user is able to filter the holiday recipes
- [x] the user is able to set personal data in configuration file - _user doesn't need configuration file, application uses Backendless database_
- [x] docummentation
- [x] tests