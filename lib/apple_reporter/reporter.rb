module AppleReporter
  class Reporter
    ENDPOINT = 'https://reportingitc-reporter.apple.com/reportservice'

    #
    # Usage:
    # reporter = Apple::Reporter::Sale.new(user_id: 'iscreen', access_token: 'secret', account: 'myAccount')
    #
    def initialize(config = {})
      @config = {
        sales_path: '/sales/v1',
        finance_path: '/finance/v1',
        mode: 'Robot.XML',
        version: '1_0'
      }.merge(config)
    end

    private

    def fetch(api_path, params, url_params=nil)
      headers = {
        'Content-Type' => 'application/x-www-form-urlencoded'
      }
      payload = {
        userid: @config[:user_id],
        accesstoken: @config[:access_token],
        version: @config[:version],
        mode: @config[:mode],
        queryInput: "[p=Reporter.properties, #{params}]"
      }
      payload[:account] = @config[:account] if @config[:account]
      payload[:password] = @config[:password] if @config[:password]

      response = RestClient.post("#{ENDPOINT}#{api_path}", "jsonRequest=#{payload.to_json}#{url_params}", headers)
      handle_response(@config[:mode], response)
    rescue RestClient::ExceptionWithResponse => err
      if err.response
        handle_response(@config[:mode], err.response)
      else
        raise err
      end
    end

    #
    def handle_response(mode, response)
      if response.code == 200
        if response.headers[:content_type] == 'application/a-gzip'
          io = StringIO.new(response.body)
          gz = Zlib::GzipReader.new(io)
          return gz.readlines.join
        else
          handle_response_body_with_mode(response.body, mode)
        end
      else
        handle_response_body_with_mode(response.body, mode)
      end
    end

    def handle_response_body_with_mode(body, mode)
      if mode =~ /robot\.xml/i
        Hash.from_xml(body)
      else
        body
      end
    end
  end
end
