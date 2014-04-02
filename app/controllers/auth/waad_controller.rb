class Auth::WaadController < ApplicationController
  def index
  end

  def authorize
    redirect_to client.auth_code.authorize_url(
                    :redirect_uri => auth_waad_callback_url,
                    :resource => 'https://outlook.office365.com/'
                )
  end

  def callback
    @access_token = client.auth_code.get_token(
        params[:code],
        :redirect_uri => auth_waad_callback_url
    )

    #
    # Here we need to save somewhere oauth token object
    #
    session[:oauth_token] = @access_token.to_hash

    redirect_to auth_waad_path
  end

  private

  def client
    conn = WAAD::Connector.new
    conn.client
  end
end
