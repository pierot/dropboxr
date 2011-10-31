require 'spec_helper'

describe Album do
  before(:each) do
    @attr = {:name => 'een naam', :path => '/een_path'}
  end

  it "accepts a name and path" do
    a = Album.create(@attr)

    a.should be_valid
  end

  it "fails when providing empty name" do
    a = Album.create(@attr.merge({:name => ''}))

    a.should_not be_valid
  end

  it "fails when providing empty path" do
    a = Album.create(@attr.merge({:path => ''}))

    a.should_not be_valid
  end

  it "has a slug when an album is created" do
    a = Album.create(@attr)

    a.slug.should_not be_empty
  end

  it "changes his slug when an album is updated" do
    a = Album.create(@attr)
    s = a.slug

    a.name = "new name"
    a.save

    a.slug.should_not == s
  end

  it "accepts multiple photos" do
    attr = {:name => 'foto', :path => '/foto_path', :revision => '-', :modified => '-' }

    a = Album.create(@attr)
    
    1..5.times do
      a.photos << Photo.create(attr)
    end

    a.photos.length.should == 5
  end
end
