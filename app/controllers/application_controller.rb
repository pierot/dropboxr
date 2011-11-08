class ApplicationController < ActionController::Base
  protect_from_forgery

  def dropboxr_conn
    logger.info "Fetching Dropboxr Conn"

    if Dropboxr::Application.config.dbr.nil?
      session_key = ''
      session_key = Installation.installed.first.session_key unless Installation.installed.empty?

      Dropboxr::Application.config.dbr = Dropboxr::Connector.new('oxye3gyi03lqmd4', 'ysr84fd8hy49v9k', session_key)
    end

    Dropboxr::Application.config.dbr
  end
end
