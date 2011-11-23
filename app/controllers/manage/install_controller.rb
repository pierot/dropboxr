class Manage::InstallController < ApplicationController
  def index
    dbr_conn = Dropboxr::Connector.connection
    dbr_conn.redirect_url = callback_manage_install_index_url

    unless dbr_conn.authorized? && !Installation.installed.empty?
      redirect_to dbr_conn.authorize_user_url
    else
      redirect_to done_manage_install_index_path
    end
  end

  def callback
    dbr_conn = Dropboxr::Connector.connection

    if params[:oauth_token]
      if dbr_conn.authorize_user(params)
        Installation.delete_all # fuck it

        insta = Installation.new({:session_key => dbr_conn.session_serialized})
        insta.save

        redirect_to done_manage_install_index_path
      else
        redirect_to error_manage_install_index_path
      end
    else
      redirect_to root_path
    end
  end

  def done
  end

  def error
  end
end
