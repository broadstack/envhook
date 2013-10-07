module Envhook
  class Config

    def self.username
      ENV.fetch("ENVHOOK_USER")
    end

    def self.password
      ENV.fetch("ENVHOOK_PASS")
    end

    def self.credentials
      [username, password]
    end

  end
end
