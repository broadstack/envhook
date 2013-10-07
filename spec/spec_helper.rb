require "rspec"
require "rack/test"
require "envhook"

module EnvhookSpecHelper

  include Rack::Test::Methods

  def self.included(klass)
    klass.before do
      ENV["ENVHOOK_USER"] = "testuser"
      ENV["ENVHOOK_PASS"] = "testpass"
    end
  end

  def app
    Rack::Builder.app do
      map "/_envhook" do
        run Envhook::App.build
      end
    end
  end

  def username; Envhook::Config.username end
  def password; Envhook::Config.password end

  def envhook_auth
    authorize(username, password)
  end

  alias_method :response, :last_response

end

RSpec.configure do |rspec|
  rspec.include(EnvhookSpecHelper)
end
