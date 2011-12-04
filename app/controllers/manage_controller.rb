class ManageController < ApplicationController
  before_filter :require_login

  def index
    @count_photos = Photo.all.length
    @count_cached_photos = Photo.cached.length
    @count_not_cached_photos = Photo.not_cached.length
  end

  protected

    def require_login
      authenticate_or_request_with_http_basic('Restricted Area') do |username, password|
        username == Dropboxr::Application.config.auth_username && password == Dropboxr::Application.config.auth_password
      end
    end

end
