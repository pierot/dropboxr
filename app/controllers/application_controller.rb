class ApplicationController < ActionController::Base
  protect_from_forgery

  def dropboxr_conn
    logger.info "Fetching Dropboxr Conn"

    c = Dropboxr::Application.config

    if c.dbr.nil?
      session_key = ''
      session_key = Installation.installed.first.session_key unless Installation.installed.empty?

      c.dbr = Dropboxr::Connector.new :key => c.dbr_key, :secret => c.dbr_secret, :session_key => session_key
    end

    c.dbr
  end
end
