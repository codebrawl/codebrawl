# [Codebrawl](http://codebrawl.com)

Codebrawl, a code contest website focussed on the Ruby programming language and open source software.

## Getting the project to run on your machine

First, check out the project:

    git clone git://github.com/codebrawl/codebrawl.git && cd codebrawl

When `cd`-ing into the project directory, you'll get an [RVM](https://rvm.beginrescueend.com/) notice telling you to read the `.rvmc`. There's nothing scary in there (it switches to a Codebrawl specific gemset on Ruby 1.9.2), but be sure to _always_ read this file when prompted to. Press enter to see the file, then type "yes" to switch to the gemset.

Install [Bundler](http://gembundler.com/) in your new gemset and use it to install Codebrawl's dependencies:

    gem install bundler && bundle install

Copy the example config file:

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
* Refactor existing code

Fork the project, add your changes (with specs), and send a pull request. Thanks for helping out! :)
