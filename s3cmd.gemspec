require File.expand_path("../.gemspec", __FILE__)
require File.expand_path("../lib/s3cmd/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "s3cmd"
  gem.authors     = ["Samuel Kadolph"]
  gem.email       = ["samuel@kadolph.com"]
  gem.description = readme.description
  gem.summary     = readme.summary
  gem.homepage    = "https://github.com/samuelkadolph/s3cmd"
  gem.version     = S3Cmd::VERSION

  gem.files       = Dir["bin/*", "lib/**/*"]
  gem.executables = Dir["bin/*"].map(&File.method(:basename))

  gem.required_ruby_version = ">= 1.8.7"

  gem.add_dependency "aws", "~> 2.8.0"
  gem.add_dependency "mime-types", "~> 1.22"
  gem.add_dependency "proxifier", "~> 1.0.3"
  gem.add_dependency "thor", "~> 0.18.1"

  gem.add_development_dependency "rake", "~> 10.0.4"
end
