module Envhook

  # Re-executing the running single-process server.
  #
  # Mostly lifted from Unicorn and trimmed down:
  # https://github.com/defunkt/unicorn/blob/master/lib/unicorn/http_server.rb
  class Executioner

    # * 0     - Path to server executable. You may changed this at runtime.
    # * :argv - Deep copy of the ARGV array the executable originally saw.
    # * :cwd  - Original working directory, where server was started from.
    START_CTX = {
      :argv => ARGV.map { |arg| arg.dup },
      0 => $0.dup,
    }

    # We favor ENV['PWD'] since it is (usually) symlink aware for Capistrano
    # and like systems
    START_CTX[:cwd] = begin
      a = File.stat(pwd = ENV['PWD'])
      b = File.stat(Dir.pwd)
      a.ino == b.ino && a.dev == b.dev ? pwd : Dir.pwd
    rescue
      Dir.pwd
    end

    # reexecutes the START_CTX with a new binary
    def reexec
      if pid = fork
        reexec_parent(pid)
      else
        reexec_child
      end
    end

    private

    def reexec_parent(pid)
    end

    def reexec_child
      pid = Process.pid
      ppid = Process.ppid

      logger.info "forked PID:#{pid} from parent PID:#{ppid}"

      signal = "TERM"
      logger.info "sending #{signal} to PID:#{ppid}"
      Process.kill(signal, ppid)

      logger.info "waiting for PID:#{ppid} to exit"
      wait_for_pid(ppid)

      logger.info "changing directory to #{context[:cwd]}"
      Dir.chdir(context[:cwd])
      cmd = [ context[0] ].concat(context[:argv])

      logger.info "executing #{cmd.inspect} (in #{Dir.pwd})"
      exec(*cmd)
    end

    # Wait for a process to exit (for the PID to no longer exist).
    # Requires privileges to send a (null) signal to the pid.
    def wait_for_pid(pid)
      loop do
        Process.kill(0, pid)
        sleep(0.01)
      end
    rescue Errno::ESRCH
      return
    end

    # The START_CTX, with modifications applied.
    def context
      @_context ||= {
        :argv => START_CTX[:argv].map { |arg| arg.dup },
        :cwd => START_CTX[:cwd].dup,
        0 => START_CTX[0].dup,
      }.tap do |ctx|
        rewrite_context(ctx)
      end
    end

    def rewrite_context(ctx)
      # Rails mangles ARGV :(
      if ctx[0] == "bin/rails" && !["server", "s"].include?(ctx[:argv][0])
        # Chances are it was `rails server`
        ctx[:argv].unshift("server")
      end
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
