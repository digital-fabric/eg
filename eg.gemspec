require_relative('lib/eg/version')

Gem::Specification.new do |s|
  s.name        = 'eg'
  s.version     = EG::VERSION
  s.licenses    = ['MIT']
  s.summary     = 'EG: Prototype-based objects for Ruby'
  s.author        = 'Sharon Rosner'
  s.email         = 'ciconia@gmail.com'
  s.files         = `git ls-files`.split
  s.homepage      = 'http://github.com/digital-fabric/eg'
  s.metadata      = { "source_code_uri" => "https://github.com/digital-fabric/eg" }
  s.rdoc_options  = ["--title", "EG", "--main", "README.md"]
  s.extra_rdoc_files = ["README.md", "CHANGELOG.md"]

  s.add_runtime_dependency      'modulation', '~> 0.20'
  s.add_development_dependency  'minitest',   '5.11.3'
end