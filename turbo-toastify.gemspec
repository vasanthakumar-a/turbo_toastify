lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "turbo_toastify/version"

Gem::Specification.new do |spec|
  spec.name          = "turbo-toastify"
  spec.version       = TurboToastify::VERSION
  spec.authors       = ["vasanthakumar-a"]
  spec.email         = ["vasanthakumara117@gmail.com"]

  spec.summary       = "Turbo and Stimulus friendly toast notifications for Rails."
  spec.description   = "A lightweight Rails gem providing a framework-agnostic toast notification system with seamless Turbo and Stimulus integration."
  spec.homepage      = "https://github.com/vasanthakumar-a/turbo_toastify"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 1.9.3"

  spec.metadata = {
    "source_code_uri"   => "https://github.com/vasanthakumar-a/turbo_toastify",
    "changelog_uri"     => "https://github.com/vasanthakumar-a/turbo_toastify/blob/main/CHANGELOG.md",
    "bug_tracker_uri"   => "https://github.com/vasanthakumar-a/turbo_toastify/issues",
    "documentation_uri" => "https://github.com/vasanthakumar-a/turbo_toastify#readme"
  }

  spec.files = Dir.chdir(__dir__) do
    Dir[
      "lib/**/*",
      "README.md",
      "MIT-LICENSE"
    ]
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 4.2", "< 9.0"
end
