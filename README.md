envhook
=======

A Rack middleware webhook receiver to update your `.env`.


Installation
------------

Add this line to your application's Gemfile:

    gem 'envhook'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install envhook


Details
-------

Envhook receives HTTP requests containing configuration,
writes it to a `.env` file, and restarts the web application.

* Receives HTTP request with JSON-encoded configuration.
* Authenticates based on `ENVHOOK_USER` and `ENVHOOK_PASS` in ENV.
* Overwrites the configuration into `.env`.
* Restart the web application:
  * Unicorn: send `SIGUSR2` to parent process.
    * Specifics depends on Unicorn configuration.
    * e.g. `preload_app`.
    * e.g. whether the config sends `SIGQUIT` to old master.
  * WEBrick, other single-process servers: re-exec.
    * Fork.
    * Re-execute original command.
    * Send `SIGTERM` to parent.
  * Custom: shell out to a preconfigured arbitrary command.
    * Preferred; uses your existing method of restarting.
    * e.g. `/etc/init.d/my_application restart`

Note that even in a single-process, single-threaded app server,
it is necessary to restart as `ENV` vars are generally consumed
by initializers / start-up configuration.


Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
