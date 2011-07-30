# [Codebrawl](http://codebrawl.com)

Open source hacking contests in the Ruby programming langauge

## Contact

* [Github (codebrawl)](http://github.com/codebrawl)
* [Twitter (@codebrawl)](http://twitter.com/codebrawl)
* [IRC (#codebrawl @ freenode.net)](irc://irc.freenode.net/codebrawl)

## Getting the project to run on your machine

We're trying to make it as easy as possible to get Codebrawl running on your machine. If you run into any problems getting it to run or know an easier way, be sure to create an [issue](https://github.com/codebrawl/codebrawl/issues).

First, clone the project:

    git clone git://github.com/codebrawl/codebrawl.git && cd codebrawl

Use [Bundler](http://gembundler.com/) to install the dependencies:

    bundle install

The real config file is not checked in, for obvious reasons, so you'll have to use the example config:

    cp config/codebrawl.example.yml config/codebrawl.yml

Now, run the tests and make sure they all pass:

    bundle exec rspec spec

If you get a spec failure, please create an [issue](https://github.com/codebrawl/codebrawl/issues) explaining what went wrong.

## Helping out

Want to help out, but have no idea where to get started? Here's a list of things you can do:

* Check out the [tracker](https://www.pivotaltracker.com/projects/326833), choose an (unassigned) story, join the project and assign it to yourself
* Check out the open [issues](https://github.com/codebrawl/codebrawl/issues)
* Hop into `#codebrawl` on Freenode and ask
* Find a `TODO` in the source, so you can help clean up a bit
* Refactor existing code (that includes the front end too)

If you found something to work on, fork the project. Codebrawl uses [git-flow](https://github.com/nvie/gitflow), but don't let that scare you, you can just work in the develop branch. Now, add your changes and be sure to write specs for them. If you don't know how or get stuck somewhere, hop into [#codebrawl on freenode.net](irc://irc.freenode.net/codebrawl) and we'll help you out. When you're done, just send a pull request and we'll look at it as soon as possible.
