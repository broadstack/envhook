module Envhook
  class Controller

    def initialize(request, response)
      @request = request
      @response = response
    end

    def call
    end

    private

    attr_reader :request
    attr_reader :response

  end
end
