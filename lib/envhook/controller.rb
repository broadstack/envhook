module Envhook
  class Controller

    def initialize(request, response)
      @request = request
      @response = response
    end

    def call
      config = parse_config
      write_config(config)
      reload_config(config) # TODO
    end

    private

    def parse_config
      # TODO: validate that keys and values are all Strings.
      JSON.parse(http_request_body)
    end

    def write_config(config)
      log "Writing config"
      Writer.new(config).write
    end

    def reload_config(config)
      log "Reloading config"

      # For single-process app servers.
      ::Envhook::Executioner.new.reexec
    end

    def http_request_body
      request.body.rewind
      request.body.read
    end

    def log(message)
      # TODO: better.
      puts("Envhook: " << message)
    end

    def reexec
    end

    attr_reader :request
    attr_reader :response

  end
end
