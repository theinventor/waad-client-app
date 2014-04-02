module WAAD

  class Connector
    attr_reader :client

    def initialize
      @client = connection(credentials)
    end

    def credentials
      hash = {}
      hash[:client_id] = '833686ca-1811-4fda-a148-ac8865ab1a7d'
      hash[:client_secret] = 'othybibNtwWVmRHHeR+GGdLOdNyNMxGrwUcevoYOokQ='
      hash
    end

    def connection(credentials)
      #token_endpoint = 'https://login.windows.net/9ae3f0b0-7feb-44a4-9b1d-98f8fe7f98f4/oauth2/token?api-version=1.0'
      #auth_endpoint = 'https://login.windows.net/9ae3f0b0-7feb-44a4-9b1d-98f8fe7f98f4/oauth2/authorize?api-version=1.0'
      OAuth2::Client.new(
          credentials[:client_id],
          credentials[:client_secret],
          :site => credentials[:resource],
          :authorize_url => 'https://login.windows.net/common/oauth2/authorize',
          :token_url => 'https://login.windows.net/common/oauth2/token'
      )
    end
  end

  class Wrapper

    def initialize(client, oauth_token_hash)
      @client = client
      @access_token = token(oauth_token_hash)
    end

    def refresh!
      @access_token = @access_token.refresh!
    end

    def expired?
      @access_token.expired?
    end

    #----------------#
    #--- Calendar ---#
    #----------------#

    #
    # For details look here:
    # http://msdn.microsoft.com/en-us/library/office/dn605896(v=office.15).aspx
    #

    def get_calendar_groups
      get 'Me/CalendarGroups'
    end

    def get_calendars
      get 'Me/Calendars'
    end

    def get_events(params = nil)
      get 'Me/Calendar/Events', params
    end

    def create_event(params)
      post 'Me/Calendar/Events', params
    end

    def delete_event(id)
      delete 'Me/Calendar/Event', id
    end


    private

    def token(hash)
      OAuth2::AccessToken.from_hash(@client, hash)
    end

    def full_path(resource)
      "ews/odata/#{resource}"
    end

    def get(resource, params = nil)
      response = @access_token.get( full_path(resource), :params => params )
      response.parsed
    end

    def post(resource, data)
      response = @access_token.post( full_path(resource), { body: data } )
      response.status == 200 ? response.parsed : response.status
    end

    def put(resource, data)
      response = @access_token.put( full_path(resource), { body: data } )
      response.status
    end

    def delete(resource, data)
      response = @access_token.delete( full_path(resource), { body: data } )
      response.status
    end

  end
end