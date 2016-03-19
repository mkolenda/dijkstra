# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dijkstra/version'

Gem::Specification.new do |spec|
  spec.name          = "dijkstra"
  spec.version       = Dijkstra::VERSION
  spec.authors       = ["Matt Kolenda"]
  spec.email         = ["mkolenda@gmail.com"]

  spec.summary       = %q{Dijkstra's algorithm is an algorithm for finding the shortest paths between nodes in a graph.}
  spec.description   = %q{Djikstra's algorithm is a graph-based technique for finding the globally shortest path between a starting node and a target node in a non-negative weighted Directed Acyclic Graph (DAG). It is a DAG in that edges are one way and there are no cycles in the graph; it is weighted in that each traversal of the graph has a certain cost. It is used often in graph-based applications such as social, network routing, and logistics supply modeling.}
  spec.homepage      = "https://github.com/mkolenda"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
