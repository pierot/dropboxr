Dropboxr::Application.config.dbr = Dropboxr::Connector.new( 'oxye3gyi03lqmd4', 
                                                            'ysr84fd8hy49v9k', 
                                                            Installation.installed.empty? ? '' : Installation.installed.first.session_key)
