class ManageController < ApplicationController

  def index
  end

  def cache
    Resque.enqueue(Cacher)
  end

end
