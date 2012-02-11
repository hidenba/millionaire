require 'pathname'

RSpec.configure do |config|
end

def RSpec.root
  @spec_root ||= Pathname.new(File.dirname(__FILE__))
end
