##ASSUMPTIONS

This tutorial assumes the following:
* You have ruby installed
* You have a github account
  * SSH pub key set up
* You have a rubygems.org account

##INTRODUCTION

Creating and publishing your own gem is simple thanks to the tools baked right into RubyGems. Let’s make a simple “hello world” gem. The code for the gem we’re going to make is up on [GitHub](https://github.com/TVSZE/RubyProject).

Remember if you are doing this under Windows as I was doing it, use "Administrator: Start Command prompt with Ruby".

---

##YOUR FIRST GEM

I started with just one Ruby file for my **hello** gem, and the gemspec. You’ll need a new name for yours (maybe **hello_yourusername** in my case **hello_tvsze**) to publish it. Check the [Patterns guide](http://guides.rubygems.org/patterns/#consistent-naming) for basic recommendations to follow when naming a gem.

```
% tree
.
├── hello_tvsze.gemspec
└── lib
    └── hello_tvsze.rb
```

Code for your package is placed within the lib directory. The convention is to have one Ruby file with the same name as your gem, since that gets loaded when require **'hello_tvsze'** is run. That one file is in charge of setting up your gem’s code and API.

The code inside of **lib/hello_tvsze.rb** is pretty bare bones. It just makes sure that you can see some output from the gem:

```ruby
% cat lib/hello_tvsze.rb
class Hello_tvsze
  def self.hi
    puts "Hello world!"
  end
end
```

The gemspec defines what’s in the gem, who made it, and the version of the gem. It’s also your interface to RubyGems.org. All of the information you see on a gem page (like jekyll’s) comes from the gemspec.

```ruby
% cat hello_tvsze.gemspec
Gem::Specification.new do |s|
  s.name        = 'hello_tvsze'
  s.version     = '0.0.0'
  s.date        = '2014-11-29'
  s.summary     = "Hello world gem!"
  s.description = "A simple hello world gem"
  s.authors     = ["Varga Tamas"]
  s.email       = 'varga.tamas.8@inf.u-szeged.hu'
  s.files       = ["lib/hello_tvsze.rb"]
  s.homepage    =
      'https://github.com/TVSZE/RubyProject'
  s.license       = 'MIT''
end
```
>The description member can be much longer than you see in this example. If it matches /^== [A-Z]/ then the description will be run through RDoc’s markup formatter for display on the RubyGems web site. Be aware though that other consumers of the data might not understand this markup.


Look familiar? The gemspec is also Ruby, so you can wrap scripts to generate the file names and bump the version number. There are lots of fields the gemspec can contain. To see them all check out the full [reference](http://guides.rubygems.org/specification-reference).

After you have created a gemspec, you can build a gem from it. Then you can install the generated gem locally to test it out.

```
% gem build hello_tvsze.gemspec
  Successfully built RubyGem
  Name: hello_tvsze
  Version: 0.0.0
  File: hello tvsze-0.0.0.gem

% gem install ./hello_tvsze-0.0.0.gem
Successfully installed hello_tvsze-0.0.0
Parsing documentation for hello_tvsze-0.0.0
Installing ri documentation for hello_tvsze-0.0.0
Done installing documentation for hello_tvsze after 0 seconds
1 gem installed
```

Of course, the smoke test isn’t over yet: the final step is to **require** the gem and use it:

```
% irb
>> require 'hello_tvsze'
=> true
>> Hello_tvsze.hi
Hello world!
```

>If you’re using an earlier Ruby than 1.9.2, you need to start the session with **irb -rubygems** or require the rubygems library after you launch irb.

Now you can share hello_tvsze with the rest of the Ruby community. Publishing your gem out to RubyGems.org only takes one command, provided that you have an account on the site. To setup your computer with your RubyGems account:

```
$ curl -u qrush https://rubygems.org/api/v1/api_key.yaml >
%USERPROFILE%/.gem/credentials

Enter host password for user 'TVSZE':
```

>If you’re having problems with curl, OpenSSL, or certificates, you might want to simply try entering the above URL in your browser’s address bar. Your browser will ask you to login to RubyGems.org. Enter your username and password. Your browser will now try to download the file api_key.yaml. Save it in ~/.gem and call it ‘credentials’

Once this has been setup, you can push out the gem:

```
% gem push hello_tvsze-0.0.0.gem
Pushing gem to https://rubygems.org...
Successfully registered gem: hello_tvsze (0.0.0)
```

Sometimes you can get error messages such as

```
ERROR:  While executing gem ... (Gem::RemoteFetcher::FetchError)
    SocketError: getaddrinfo: No such host is known.  (http://rubygems.org/quick
/Marshal.4.8/rubygems-update-2.4.4.gemspec.rz)
```
This is apparently related to rubygems.org being not consistently reachable. Best suggestion I can give is just wait a bit and try pushing your gem later.

In just a short time (usually less than a minute), your gem will be available for installation by anyone. You can see it [on the RubyGems.org site](https://rubygems.org/gems/hello_tvsze) or grab it from any computer with RubyGems installed:

```
% gem list -r hello_tvsze

*** REMOTE GEMS ***

hello_tvsze (0.0.0)

% gem install hello_tvsze
Successfully installed hello_tvsze-0.0.0
1 gem installed
Installing ri documentation for hello_tvsze-0.0.0...
Installing RDoc documentation for hello_tvsze-0.0.0...
```

It’s really that easy to share code with Ruby and RubyGems.

##REQUIRING MORE FILES

Having everything in one file doesn’t scale well. Let’s add some more code to this gem.


```ruby
% cat lib/hello_tvsze.rb
class Hello_tvsze
  def self.hi(language = "english")
    translator = Translator.new(language)
    translator.hi
  end
end

class Hello_tvsze::Translator
  def initialize(language)
    @language = language
  end

  def hi
    case @language
      when "hungarian"
        "Szia világ"
      else
        "hello world"
    end
  end
end
```

This file is getting pretty crowded. Let’s break out the **Translator** into a separate file. As mentioned before, the gem’s root file is in charge of loading code for the gem. The other files for a gem are usually placed in a directory of the same name of the gem inside of **lib**. We can split this gem out like so:

```
% tree
.
├── hello_tvsze.gemspec
└── lib
    ├── hello_tvsze
    │   └── translator.rb
    └── hello_tvsze.rb
```
The **Translator** is now in **lib/hello_tvsze**, which can easily be picked up with a **require** statement from **lib/hello_tvsze.rb**. The code for the **Translator** did not change much:

```ruby
% cat lib/hello_tvsze/translator.rb
# encoding: utf-8

class Translator
  def initialize(language)
    @language = language
  end

  def hi
    case @language
    when "hungarian"
      "Szia világ"
    else
      "hello world"
    end
  end
end
```
> Don't forget to set the encoding if translator.rb to something that can handle special characters if you used any. UTF-8 is generally a good choice.

But now the **hello_tvsze.rb** file has some code to load the **Translator**:

```ruby
% cat lib/hello_tvsze.rb
class Hello_tvsze
  def self.hi(language = "english")
    translator = Translator.new(language)
    translator.hi
  end
end

require 'hello_tvsze/translator'
```
> Gotcha: For newly created folder/file, do not forget to add one entry in hello_tvsze.gemspec file, as shown-

```ruby
% cat hello_tvsze.gemspec
Gem::Specification.new do |s|
...
s.files       = ["lib/hello_tvsze.rb", "lib/hello_tvsze/translator.rb"]
...
end
```
> without the above change, new folder would not be included into the installed gem.

Let’s try this out. First, fire up **irb**:

```
% irb -Ilib -rhello_tvsze
irb(main):001:0> Hello_tvsze.hi("english")
=> "hello world"
irb(main):002:0> Hello_tvsze.hi("hungarian")
=> "Szia vil\u00E1g"
```
We need to use a strange command line flag here: **-Ilib**. Usually RubyGems includes the **lib** directory for you, so end users don’t need to worry about configuring their load paths. However, if you’re running the code outside of RubyGems, you have to configure things yourself. It’s possible to manipulate the **$LOAD_PATH** from within the code itself, but that’s considered an anti-pattern in most cases. There are many more anti-patterns (and good patterns!) for gems, explained in [this guide](http://guides.rubygems.org/patterns).

If you’ve added more files to your gem, make sure to remember to add them to your gemspec’s **files** array before publishing a new gem! For this reason (among others), many developers automate this with [Hoe](https://github.com/seattlerb/hoe), [Jeweler](https://github.com/technicalpickles/jeweler), [Rake](https://github.com/jimweirich/rake), [Bundler](http://railscasts.com/episodes/245-new-gem-with-bundler), or [just a dynamic gemspec](https://github.com/wycats/newgem-template/blob/master/newgem.gemspec).

Adding more directories with more code from here is pretty much the same process. Split your Ruby files up when it makes sense! Making a sane order for your project will help you and your future maintainers from headaches down the line.

##ADDING AN EXECUTABLE

In addition to providing libraries of Ruby code, gems can also expose one or many executable files to your shell’s **PATH**. Probably the best known example of this is **rake**. Another very useful one is **prettify_json.rb**, included with the [JSON](http://rubygems.org/gems/json) gem, which formats JSON in a readable manner (and is included with Ruby 1.9).

Adding an executable to a gem is a simple process. You just need to place the file in your gem’s **bin** directory, and then add it to the list of executables in the gemspec. Let’s add one for the Hello_tvsze gem. First create the file and make it executable:

```
% mkdir bin
% copy nul > bin\hello_tvsze
```

The executable file itself just needs a [shebang](http://www.catb.org/jargon/html/S/shebang.html) in order to figure out what program to run it with. Here’s what Hello_tvsze’s executable looks like:

```ruby
% cat bin/hello_tvsze
#!/usr/bin/env ruby

require 'hello_tvsze'
puts Hello_tvsze.hi(ARGV[0])
```

All it’s doing is loading up the gem, and passing the first command line argument as the language to say hello with. Here’s an example of running it:

```
% ruby -Ilib ./bin/hello_tvsze
hello world

% ruby -Ilib ./bin/hello_tvsze hungarian
Szia világ
```

Finally, to get Hello_tvsze’s executable included when you push the gem, you’ll need to add it in the gemspec.

```ruby
% cat hello_tvsze.gemspec
Gem::Specification.new do |s|
  s.name        = 'hello_tvsze'
  s.version     = '0.0.1'
  s.executables << 'hello_tvsze'
  s.date        = '2014-11-29'
  s.summary     = "Hello world gem!"
  s.description = "A simple hello world gem"
  s.authors     = ["Varga Tamas"]
  s.email       = 'varga.tamas.8@inf.u-szeged.hu'
  s.files       = ["lib/hello_tvsze.rb", "lib/hello_tvsze/translator.rb", "bin/hello_tvsze"]
  s.homepage    =
      'https://github.com/TVSZE/RubyProject'
  s.license       = 'MIT'
end
```
Push up that new gem, and you’ll have your own command line utility published!

```
$ gem build hello_tvsze.gemspec
 Successfully built RubyGem
 Name: hello_tvsze
 Version: 0.0.1
 File: hello_tvsze-0.0.1.gem

$ gem push hello_tvsze-0.0.1.gem
Pushing gem to https://rubygems.org...
Successfully registered gem: hello_tvsze (0.0.1)
```

You can add more executables as well in the **bin** directory if you need to, there’s an **executables** array field on the gemspec.

> Note that you should change the gem’s version when pushing up a new release. For more information on gem versioning, see the [Patterns Guide](http://guides.rubygems.org/patterns/#semantic-versioning)

##WRITING TESTS

Testing your gem is extremely important. Not only does it help assure you that your code works, but it helps others know that your gem does its job. When evaluating a gem, Ruby developers tend to view a solid test suite (or lack thereof) as one of the main reasons for trusting that piece of code.

Gems support adding test files into the package itself so tests can be run when a gem is downloaded. An entire community effort has sprung up called [GemTesters](http://test.rubygems.org/) to help document how gem test suites run on different architectures and interpreters of Ruby.

In short: *TEST YOUR GEM!* Please!

**Test::Unit** is Ruby’s built-in test framework. There are [lots](http://www.mikeperham.com/2012/09/25/minitest-ruby-1-9s-test-framework/) of [tutorials](https://github.com/seattlerb/minitest/blob/master/README.txt) for using it online. There are many other test frameworks available for Ruby as well. [RSpec](http://rspec.info/) is a popular choice. At the end of the day, it doesn’t matter what you use, just *TEST*!

Let’s add some tests to Hello_tvsze. This requires adding a few more files, namely a **Rakefile** and a brand new **test** directory:

```
% tree
.
├── Rakefile
├── bin
│   └── hello_tvsze
├── hello_tvsze.gemspec
├── lib
│   ├── hello_tvsze
│   │   └── translator.rb
│   └── hello_tvsze.rb
└── test
    └── test_hello_tvsze.rb
```
The **Rakefile** gives you some simple automation for running tests:

```ruby
% cat Rakefile
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test
```

Now you can run **rake test** or simply just **rake** to run tests. Woot! Here’s a basic test file for hello_tvsze:

```ruby
% cat test/test_hello_tvsze.rb
# encoding: utf-8

require 'minitest'
require 'minitest/autorun'
require 'hello_tvsze'

class Hello_tvsze_Test < Minitest::Test
  def test_english_hello
    assert_equal "hello world",
                 Hello_tvsze.hi("english")
  end

  def test_any_hello
    assert_equal "hello world",
                 Hello_tvsze.hi("ruby")
  end

  def test_hungarian_hello
    assert_equal "Szia világ",
                 Hello_tvsze.hi("hungarian")
  end
end
```

> Don't forget to set the file encoding here too in case you use special characters.

Finally, to run the tests:

```
% ruby -Ilib:test test/test_hello_tvsze.rb
(Run options: --seed 10649

 # Running:

 ...

 Finished in 0.003501s, 856.8980 runs/s, 856.8980 assertions/s.

 3 runs, 3 assertions, 0 failures, 0 errors, 0 skips
```
It’s green! Well, depending on your shell colors. For more great examples, the best thing you can do is hunt around [GitHub](https://github.com/search?utf8=%E2%9C%93&q=stars%3A%3E100+forks%3A%3E10&type=Repositories&ref=advsearch&l=Ruby) and read some code.

Might be a good idea to increment the version of the gem and push it to rubygems.org now that we have tests.

Here is the updated hello_tvsze.gemspec

```ruby
$ cat hello_tvsze.gemspec
Gem::Specification.new do |s|
  s.name          = 'hello_tvsze'
  s.version       = '0.0.2'
  s.executables   << 'hello_tvsze'
  s.date          = '2014-12-03'
  s.summary       = "Hello world gem!"
  s.description   = "A simple hello world gem"
  s.authors       = ["Varga Tamas"]
  s.email         = 'varga.tamas.8@inf.u-szeged.hu'
  s.files         = ["Rakefile", "lib/hello_tvsze.rb", "lib/hello_tvsze/translator.rb", "bin/hello_tvsze"]
  s.require_paths = ["lib"]
  s.test_files    = ["test/test_hello_tvsze.rb"]
  s.homepage      =
      'https://github.com/TVSZE/RubyProject'
  s.license       = 'MIT'
end
```

```
% gem build hello_tvsze.gemspec
 Successfully built RubyGem
 Name: hello_tvsze
 Version: 0.0.2
 File: hello_tvsze-0.0.2.gem

% gem push hello_tvsze-0.0.2.gem
Pushing gem to https://rubygems.org...
Successfully registered gem: hello_tvsze (0.0.2)
```

***

##DOCUMENTING YOUR CODE

By default most gems use RDoc to generate docs. There are plenty of [great tutorials](http://docs.seattlerb.org/rdoc/RDoc/Markup.html) for learning how to mark up your code with RDoc. Here’s a simple example:

```markup
# The main Hello_tvsze driver
class Hello_tvsze
  # Say hi to the world!
  #
  # Example:
  #   >> Hello_tvsze.hi("hungarian")
  #   => Szia világ
  #
  # Arguments:
  #   language: (String)

  def self.hi(language = "english")
    translator = Translator.new(language)
    puts translator.hi
  end
end
```
Another great option for documentation is [YARD](http://yardoc.org/), since when you push a gem, [RubyDoc.info](http://rubydoc.info/) generates YARDocs automatically from your gem. YARD is backwards compatible with RDoc, and it has a [good introduction](http://rubydoc.info/docs/yard/file/docs/GettingStarted.md) on what’s different and how to use it.

***

##WRAPUP

With this basic understanding of building your own RubyGem, we hope you’ll be on your way to making your own! 


***

##CREDITS

This tutorial was adapted from [rubygems.org](http://guides.rubygems.org/make-your-own-gem/#writing-tests) which was adapted from [Gem Sawyer, Modern Day Ruby Warrior](http://rubylearning.com/blog/2010/10/06/gem-sawyer-modern-day-ruby-warrior/). The code for this gem can be found on [GitHub](https://github.com/TVSZE/RubyProject).