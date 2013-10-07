module Envhook

  # Envhook::App (class) is the core Rack app.
  # Envhook::App (instance) is the request handler.
  # Envhook::App.build wraps it in middleware (auth, …)
  class App

    # Build the Rack app to be run or mounted in a host app.
    def self.build
      Rack::Builder.app do

        # HTTP Basic Auth.
        use(Rack::Auth::Basic, "Restricted") do |u, p|
          [u, p] == Envhook::Config.credentials
        end

        # Envhook app.
        run(::Envhook::App)

      end
    end

    # Rack entry-point
    def self.call(env)
      # RequestHandler instance per request.
      self.new(env).call.to_a
    end

    # Each request is handled by a new instance.
    def initialize(env)
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    # Processes the request, returns the response.
    def call
      case request.path_info
      when %r{\A/?config\z}
        Envhook::Controller.new(request, response).call
      else
        response.status = 404
        response.body = ["Not Found"]
        response["Content-Type"] = "text/plan"
      end
      response
    end

    private

    attr_reader :request
    attr_reader :response

  end
end
