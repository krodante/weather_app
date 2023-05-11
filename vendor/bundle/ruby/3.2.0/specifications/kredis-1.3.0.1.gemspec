# -*- encoding: utf-8 -*-
# stub: kredis 1.3.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "kredis".freeze
  s.version = "1.3.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kasper Timm Hansen".freeze, "David Heinemeier Hansson".freeze]
  s.date = "2023-03-13"
  s.email = "david@hey.com".freeze
  s.homepage = "https://github.com/rails/kredis".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7.0".freeze)
  s.rubygems_version = "3.4.13".freeze
  s.summary = "Higher-level data structures built on Redis.".freeze

  s.installed_by_version = "3.4.13" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 6.0.0"])
  s.add_runtime_dependency(%q<redis>.freeze, [">= 4.2", "< 6"])
  s.add_development_dependency(%q<rails>.freeze, [">= 6.0.0"])
end
