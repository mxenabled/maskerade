lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "maskerade/version"

::Gem::Specification.new do |spec|
  spec.name          = "maskerade"
  spec.version       = ::Maskerade::VERSION
  spec.authors       = ["Phillip Hellewell"]
  spec.email         = ["sshock@gmail.com"]

  spec.summary       = "Credit card masker"
  spec.description   = "Credit card masker with support for major credit cards and luhn check"
  spec.homepage      = "https://github.com/mxenabled/maskerade"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "luhn_checksum", "0.1.1"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "mad_rubocop"
end
