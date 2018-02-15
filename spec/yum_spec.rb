require 'spec_helper'

RSpec.describe Yum do
  it 'has a version number' do
    expect(Yum::VERSION).not_to be nil
  end

  # prepare some new user
  username = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
  username += '@somemail.com'
  password = (0...8).map { ('a'..'z').to_a[rand(26)] }.join

  # create the new client
  client = Client.new

  context '---User registration' do
    it 'registrated the user sucessfully' do
      expect do
        client.register username, password
      end.to output("Registration sucessful\n").to_stdout
    end

    it 'tried to registrate the same user' do
      expect do
        client.register username, password
      end.to output("Registration failed\n").to_stdout
    end

    it 'tried to registrate the user without password' do
      expect do
        client.register username, nil
      end.to output("Registration failed\n").to_stdout
    end

    it 'tried to registrate the user without username' do
      expect do
        client.register nil, password
      end.to output("Registration failed\n").to_stdout
    end

    it 'tried to registrate the user without arguments' do
      expect do
        client.register nil, nil
      end.to output("Registration failed\n").to_stdout
    end
  end

  context '---User login' do
    it 'tried to login wrong user' do
      expect do
        client.login 'somebody123','hisSurelyWrongPassword'
      end.to output("Login failed\n").to_stdout
    end

    it 'tried to login the user without username' do
      expect do
        client.login nil, password
      end.to output("Login failed\n").to_stdout
    end

    it 'tried to login the user without password' do
      expect do
        client.login username, nil
      end.to output("Login failed\n").to_stdout
    end

    it 'tried to login the user without arguments' do
      expect do
        client.login nil, nil
      end.to output("Login failed\n").to_stdout
    end

    it 'tried to login the user correctly' do
      expect do
        client.login username, password
      end.to output("Login success\n").to_stdout
    end
  end

  context '---User status' do
    stats = "Email: #{username}\n"
    stats += "Level: 0\n"
    stats += "XP: 0\n"

    it 'tried to display user status' do
      expect do
        client.user
      end.to output(stats).to_stdout
    end
  end

  context '---Users last food' do
    it 'tried to display last food and it should be empty plate at start' do
      expect do
        client.last
      end.to output("Empty plate\n").to_stdout
    end

    it 'tried to generate recipe and compared it with the last recipe of user' do
      expect do
        options = {}
        client.recipe options
      end.to output(client.last).to_stdout
    end
  end

  context '---Users recipe generator' do
    it 'tried to generate any food' do
      expect do
        options = {}
        client.recipe options
      end.to_not output('').to_stdout
    end

    it 'tried to generate any halloween food' do
      expect do
        options = { allowedHoliday:'halloween' }
        client.recipe options
      end.to_not output('').to_stdout
    end

    it 'tried to generate any christmas food' do
      expect do
        options = { allowedHoliday:'halloween' }
        client.recipe options
      end.to_not output('').to_stdout
    end

    it 'tried to generate food of unexisting holiday' do
      expect do
        options = { allowedHoliday:'Notexistingholiday' }
        client.recipe options
      end.to_not output('').to_stdout
    end
  end

  context '---Users review his last food' do
    it 'tried to reviewed without rating' do
      expect{ client.review nil }.to raise_error 'Rating points missing!'
    end

    it 'tried to reviewed with rating 2/3' do
      client = Client.new
      expect do
        client.review 2
      end.to output("Last food reviewed!\n").to_stdout
    end

    it 'tried to reviewed the same but there is only empty plate' do
      client = Client.new
      expect do
        client.review 2
      end.to output("Nothing to review\n").to_stdout
    end
  end
end
