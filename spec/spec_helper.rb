$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'css'

RSpec.configure do |config|
end

def fixture(path)
  File.join(File.dirname(__FILE__), 'fixtures', "#{path}")
end
