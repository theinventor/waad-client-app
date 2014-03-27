WaadClientApp::Application.routes.draw do

  namespace :auth do
    get '/waad' => 'waad#index'
    get '/waad/authorize'
    get '/waad/callback'
  end

  root 'auth/waad#index'

end
