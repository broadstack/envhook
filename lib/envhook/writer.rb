module Envhook
  class Writer

    def initialize(config)
      @config = config
    end

    # TODO: atomic write.
    # See: https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/file/atomic.rb
    def write
      File.open(dot_env_path, "w") do |f|
        f.puts header
        config.each do |key, value|
          f.puts('%s="%s"' % [key, value])
        end
      end
    end

    private

    attr_reader :config

    def dot_env_path
      ".env"
    end

    def tmp_path
      ".tmp.env"
    end

    def header
      "# Written by envhook #{Time.now}"
    end

  end
end
