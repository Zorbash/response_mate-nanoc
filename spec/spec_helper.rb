require 'response_mate'
require 'response_mate/nanoc'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end

def fixtures_path
  File.expand_path('spec/fixtures')
end
