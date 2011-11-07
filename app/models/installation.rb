class Installation < ActiveRecord::Base

  scope :installed, where("installations.session_key != ''")
  
end
