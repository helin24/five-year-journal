require 'google/api_client/client_secrets'

class UsersController < ApplicationController
  
  def index
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
        :scope => 'openid profile email',
        :redirect_uri => 'http://localhost:3000/redirect'
    )
    auth_uri = auth_client.authorization_uri.to_s
    redirect_to auth_uri
  end

  def redirect
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
        :scope => 'https://www.googleapis.com/auth/plus.login'
    )
    auth_client.code = params["code"]

    # exchanging code for an access token
    access_token = auth_client.fetch_access_token!["access_token"]

    url = URI.parse('https://www.googleapis.com/plus/v1/people/me?access_token=' + access_token)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
        http.request(req)
    }

    result = JSON.parse(res.read_body)

    if !result
        # Don't know how to do this redirection
        redirect_to index_path
    end

    email_addresses = result["emails"]
    new_email = ''
    google_auth = ''

    # should this be multiple results? Or maybe just one?
    email_addresses.each do |email|
        if google_auth = GoogleAuthentication.find_by(email: email["value"])
            break
        else
            new_email = email["value"]
        end
    end

    if google_auth.nil?
        user = User.create()
        google_auth = GoogleAuthentication.create(
            email: new_email,
            name: result["displayName"],
            profile_url: result["url"]
        )
        authentication = Authentication.create(user_id: user.id, login: google_auth)
    else
        user = User.find_by(id: google_auth.authentication.user_id)
    end
    
    session[:user_id] = user.id
    redirect_to choose_entry_path
  end

end
