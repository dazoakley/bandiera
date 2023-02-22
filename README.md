**UPDATE February, 2023: Unfortunatley I just don't have time (or the enthusiasim) to keep this project up to date and working as I'm no longer using it anywhere.  If anyone is still using this in production and would like to see it stay alive please get in touch. :smile:**

---

# Bandiera

Bandiera is a simple, stand-alone feature flagging service that is not tied to
any existing web framework or language as all communication is via a simple
REST API. It also has a simple web interface for setting up and configuring
flags.

[![CI](https://github.com/dazoakley/bandiera/actions/workflows/ci.yml/badge.svg)](https://github.com/dazoakley/bandiera/actions/workflows/ci.yml)
[![Daily Checks](https://github.com/dazoakley/bandiera/actions/workflows/daily.yml/badge.svg)](https://github.com/dazoakley/bandiera/actions/workflows/daily.yml)
[![GPLv3 licensed][shield-license]][info-license]

# Bandiera Client Libraries

- **Ruby** - [https://github.com/springernature/bandiera-client-ruby](https://github.com/springernature/bandiera-client-ruby)
- **Node** - [https://github.com/springernature/bandiera-client-node](https://github.com/springernature/bandiera-client-node)
- **Scala** - [https://github.com/springernature/bandiera-client-scala](https://github.com/springernature/bandiera-client-scala)
- **PHP** - [https://github.com/springernature/bandiera-client-php](https://github.com/springernature/bandiera-client-php)

# Deployment

The recommended way to run bandiera in production is via docker. The only dependency is a MySQL or PostgreSQL database.

Simply pull/run the bandiera image: `docker.io/dazoakley/bandiera` and pass in the `DATABASE_URL` connection string as an environment variable described below.

# Getting Started (Developers)

First, you will need the version of Ruby defined in the [.ruby-version](.ruby-version) file and [bundler](http://bundler.io/) installed. You will also need to install [phantomjs](http://phantomjs.org/) as this is used by the test suite for integration tests.

After that, set up your database (MySQL or PostgreSQL) ready for Bandiera (just an empty schema for now), and setup an environment variable with a [Sequel connection string](http://sequel.jeremyevans.net/rdoc/files/doc/opening_databases_rdoc.html) i.e.

```
export DATABASE_URL='postgres://bandiera:bandiera@localhost/bandiera'
```

If you don't have a local database server setup you can use PostgreSQL configured in the docker-compose file like so (and set your DATABASE_URL as above):

```
docker-compose up -d db
```

Now install the dependencies, setup the database and run the app server:

```
bundle install
bundle exec rake db:migrate
bundle exec shotgun -p 5000 -s puma
```

You can now visit the web interface at
[http://127.0.0.1:5000](http://127.0.0.1:5000).

Use this command to run the test suite:

```
bundle exec rspec
```

Or if you prefer to use [Guard](https://github.com/guard/guard):

```
bundle exec guard -i -p -l 1
```

Now you're ready to go.

# Other Documentation

All other documentation can be found on the [Bandiera Wiki](https://github.com/dazoakley/bandiera/wiki)

# License

[&copy; 2015, Springer Nature][info-license].

Bandiera is licensed under the [GNU General Public License 3.0][gpl].

[gpl]: http://www.gnu.org/licenses/gpl-3.0.html
[info-license]: LICENSE
[shield-license]: https://img.shields.io/badge/license-GPLv3-blue.svg
