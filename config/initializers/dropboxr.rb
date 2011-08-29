session_key = ''

begin 
  session_key =  Installation.installed.first.session_key unless Installation.installed.empty?
rescue ActiveRecord::StatementInvalid
  #  
end

Dropboxr::Application.config.dbr = Dropboxr::Connector.new( 'oxye3gyi03lqmd4', 
                                                            'ysr84fd8hy49v9k', 
                                                            session_key)
