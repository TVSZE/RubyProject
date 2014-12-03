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