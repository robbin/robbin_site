PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path('../../config/boot', __FILE__)

FactoryGirl.find_definitions
DatabaseCleaner.strategy = :transaction

class MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
    
  def app
    ##
    # You can handle all padrino applications using instead:
    #   Padrino.application
    RobbinSite.tap { |app|  }
  end
end
