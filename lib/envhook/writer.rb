module Envhook
  class Writer

    def initialize(config)
      @config = config
    end

    # TODO: atomic write.
    # See: https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/file/atomic.rb
    def write
      logger.info "Writing to #{dot_env_path} (PWD: #{Dir.pwd})"
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
      file = ENV.fetch("ENVHOOK_FILE", ".env")
      if defined?(Rails)
        Rails.root.join(file)
      else
        file
      end
    end

    def header
      "# Written by envhook #{Time.now}"
    end

    def logger
      # TODO: proper logger throughout Envhook.
      @_logger ||= defined?(Rails) ? Rails.logger : Class.new do
        def info(message); puts("Envhook[#{$$}]: " << message) end
        alias_method :error, :info
      end.new
    end

  end
end
