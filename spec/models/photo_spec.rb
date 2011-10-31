require 'spec_helper'

describe Photo do
  before(:each) do
    @attr = {:name => 'foto', :path => '/foto_path', :revision => '-', :modified => '-' }
  end

  it "accepts valid arguments" do
    p = Photo.create(@attr)

    p.should be_valid
  end

  it "fails when giving no name" do
    p = Photo.create @attr.merge(:name => '')

    p.should_not be_valid
  end

  it "fails when giving no path" do
    p = Photo.create @attr.merge(:path => '')

    p.should_not be_valid
  end

  it "fails when giving no revision attr" do
    p = Photo.create @attr.merge(:revision => '')

    p.should_not be_valid
  end

  it "fails when giving no modified attr" do
    p = Photo.create @attr.merge(:modified => '')

    p.should_not be_valid
  end

  it "belongs to an album" do
    a = Album.create({:name => 'test', :path => '/'})
    p = Photo.create @attr

    a.photos << p

    p.should == a.photos.first
  end
end
