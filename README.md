[![Gem Version](https://img.shields.io/gem/v/hephaestoss.svg)][gem]
[![Build Status](https://img.shields.io/travis/socrata-platform/hephaestoss.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/socrata-platform/hephaestoss.svg)][code
climate]
[![Coverage Status](https://img.shields.io/coveralls/socrata-platform/hephaestoss.svg)][coveralls]
[![Dependency Status](https://img.shields.io/gemnasium/socrata-platform/hephaestoss.svg)][gemnasiu
m]

[gem]: https://rubygems.org/gems/hephaestoss
[travis]: https://travis-ci.org/socrata-platform/hephaestoss
[codeclimate]: https://codeclimate.com/github/socrata-platform/hephaestoss
[coveralls]: https://coveralls.io/r/socrata-platform/hephaestoss
[gemnasium]: https://gemnasium.com/socrata-platform/hephaestoss

Hephaestoss
===========

A work-in-progress OSS refactoring of various components of the Hephaestus
project.

Hephaestus is an internal tool used to drive AWS CloudFormation stacks via
TOML configuration files. Over time, the project has become increasingly
brittle while also remaining tightly coupled to our specific CF stacks. This
set of libraries is an attempt to break that coupling and open source the
pieces of Hephaestus that we can.

It should be noted that this tool predates more modern ones with similar goals,
such as [Terraform](https://terraform.io),
[Chef Provisioning](https://github.com/chef/chef-provisioning), and
[SparkleFormation](http://www.sparkleformation.io). These other
options are both promising and gaining significant community support. This
project's existence should not be read as an indictment of or attempt at
competing with any of them.

Requirements
------------

Installation
------------

Add this gem to your project's Gemfile:

    gem 'hephaestoss'

...or install it in your Ruby environment manually:

    $ gem install hephaestoss

Usage
-----

Development
-----------

Contributing
------------

Pull requests are very welcome! Make sure your patches are well tested. Ideally
create a topic branch for every separate change you make. For example:

1. Fork the repo
2. `bundle install`
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Ensure your feature has tests and `rake` passes
5. Commit your changes (`git commit -am 'Added some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new Pull Request
8. Keep an eye on the PR and ensure the CI build passes

Authors
-------

Created and maintained by the Socrata Engineering team (<sysadmin@socrata.com>).

- Author: Jonathan Hartman (<jonathan.hartman@socrata.com>)

License
-------

Apache 2.0 (see [LICENSE][license]).

[license]: https://github.com/socrata-platform/hephaestoss/blob/master/LICENSE.txt
