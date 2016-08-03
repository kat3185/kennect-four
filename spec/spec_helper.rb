require 'rspec'
require 'pry'
Dir["./lib/*.rb"].each {|file| require file if file != "./lib/play_kennect_four.rb" }
