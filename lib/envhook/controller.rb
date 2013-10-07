module Envhook
  class Controller

    def initialize(request, response)
      @request = request
      @response = response
    end

    def call
      write_config
    end

    def write_config
      config = JSON.parse(request.body.read)
      Writer.new(config).write
    end

    private

    attr_reader :request
    attr_reader :response

  end
end
