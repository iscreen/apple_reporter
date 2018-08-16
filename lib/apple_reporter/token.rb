module AppleReporter
  class Token < Reporter
    # view
    #
    # Usage:
    #   token_info = token.view
    def view
      data, _ = fetch(@config[:sales_path], 'Sales.viewToken')
      data
    end

    # generate
    #
    # Usage:
    #   token_info = token.generate
    def generate
      # ported from python implementation at https://github.com/fedoco/itc-reporter/blob/master/reporter.py
      mode_backup = @config[:mode]
      @config[:mode] = 'normal' 
      _, headers = fetch(@config[:sales_path], 'Sales.generateToken')

      # generating a new token requires mirroring back a request id to the iTC server, so let's examine the response header...
      @config[:mode] = mode_backup
      url_params = "&isExistingToken=%s&requestId=%s" % ['Y', headers[:service_request_id]]
      data, _ = fetch(@config[:sales_path], 'Sales.generateToken', url_params)
      data
    end

    private

    #
    # return response headers along with (optionaly parsed body)
    def handle_response(mode, response)
      data = super
      [data, response.headers]
    end

  end
end
