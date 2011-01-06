Gem::Specification.new do |s|
  s.name = %q{css}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrew Timberlake"]
  s.date = %q{2011-01-01}
  s.description = %q{Parse, create and work with CSS files.}
  s.summary = %q{Parse, create and work with CSS files.}
  s.email = %q{andrew@andrewtimberlake.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
  ] + Dir['lib/**/*.rb']
  s.homepage = %q{http://github.com/andrewtimberlake/css}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 1.0"])
    else
      s.add_dependency(%q<bundler>, [">= 1.0"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 1.0"])
  end
end

