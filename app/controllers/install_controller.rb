class InstallController < ApplicationController
  before_filter :check_installation

  def index
    dbr_conn = dropboxr_conn

    unless dbr_conn.authorized?
      dbr_conn.redirect_url = install_callback_url

      redirect_to dbr_conn.authorize_user_url
    else
      redirect_to install_done_path
    end
  end

  def callback
    dbr_conn = dropboxr_conn
 
    if params[:oauth_token]
      if dbr_conn.authorize_user(params)
        Installation.delete_all # fuck it

        i = Installation.new
        i.session_key = dbr_conn.session_serialized
        i.save

        redirect_to install_done_path
      else
        redirect_to install_error_path
      end
    else
      redirect_to root_path
    end

  end

  def done

  end

  def error
    
  end

  private

    def check_installation
      Installation.installed.empty?
    end

end
