# frozen_string_literal: true
lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative "lib/soliton/version"

Gem::Specification.new do |s|
  s.name = "soliton"
  s.version = Soliton::VERSION
  s.summary = "Hola!"
  s.description = "web framework in ruby"
  s.authors = ["hikaru-nakayama"]
  s.email = "example@gmail.com"
  s.files = Dir["lib/**/*"]
  s.homepage = "https://github.com/hikaru-nakayama/soliton"
  s.license = "MIT"
  s.required_ruby_version = ">=3.2.2"
  s.metadata["rubygems_mfa_required"] = "true"
  s.metadata["github_repo"] = "https://github.com/hikaru-nakayama/soliton"
  s.executables = "soliton"
end
