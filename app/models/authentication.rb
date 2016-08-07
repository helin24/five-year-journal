class Authentication < ActiveRecord::Base
  enum login_type: [:GoogleAuthentication]
  belongs_to :user
  belongs_to :login, polymorphic: true


end
