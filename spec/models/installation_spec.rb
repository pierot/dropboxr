require 'spec_helper'

describe Installation do
  it "is not installed when empty" do
    Installation.installed.should be_empty
  end

  it 'accepts a session key' do
    i = Installation.create({:session_key => 'key'})

    i.should be_valid
  end

  it "is installed when not empty" do
    Installation.create({:session_key => 'key'})

    Installation.installed.should_not be_empty
  end
end
