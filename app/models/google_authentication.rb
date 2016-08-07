class GoogleAuthentication < ActiveRecord::Base
    has_one :authentication, as: :login
end
