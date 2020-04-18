require 'minitest/reporters'
require 'minitest/autorun'
require_relative "../lib/kaka"
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]
