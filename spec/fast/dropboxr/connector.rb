require 'fast_helper'

require 'dropboxr/calls'
require 'dropboxr/collector'
require 'dropboxr/connector'

describe Dropboxr::Connector do
  it "creates a valid instance" do
    Dropboxr::Connector.new
  end
end
