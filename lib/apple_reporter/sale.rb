require 'httparty'
# require 'active_support/core_ext/hash'
require 'nokogiri'

module AppleReporter
  class Sale
    include HTTParty

    base_uri 'https://reportingitc-reporter.apple.com/reportservice'
    default_timeout 30

    #
    # Usage:
    # reporter = Apple::Reporter::Sale.new(user_id: 'iscreen', password: 'secret', account: 'myAccount')
    #
    def initialize(config = {})
      @config = {
        sales_path: '/sales/v1',
        finance_path: '/finance/v1',
        mode: 'Robot.XML',
        version: '1.0',
      }.merge(config)
    end

    # getAccounts
    #
    # Usage:
    #   report = reporter.getAccounts
    def getAccounts
      fetch(['Sales.getAccounts'].join(', '))
    end

    # getStatus
    #
    # Usage:
    #   report = reporter.getStatus
    def getStatus
      fetch(['Sales.getStatus'].join(', '))
    end

    # getVendors
    #
    # Usage:
    #   report = reporter.getVendors
    def getVendors
      fetch(['Sales.getVendors'].join(', '))
    end

    def getVersion
      @config[:version]
    end

    # getReport
    # Refer to: https://help.apple.com/itc/appsreporterguide/
    #
    # Usage:
    #
    # report = reporter.getReport(
    #   {
    #     vendor_number: 'myVendor',
    #     report_type: 'Sales',
    #     report_sub_type: 'Summary',
    #     date_type: 'Daily',
    #     date: '20161212'
    #   }
    # )
    def getReport(params = {})
      fetch((['Sales.getReport'] + [params.slice(:vendor_number, :report_type, :report_sub_type, :date_type, :date).values.join(',')]).join(', '))
    end

    private

    def fetch(params)
      payload = {
        userid: @config[:user_id],
        password: @config[:password],
        account: @config[:account],
        version: @config[:version],
        mode: @config[:mode],
        queryInput: "[p=Reporter.properties, #{params}]"
      }
      data = {
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        },
        body: "jsonRequest=#{payload.to_json}"
      }

      response = self.class.post(@config[:sales_path], data)
      handleResponse(@config[:mode], response)
    end

    #
    def handleResponse(mode, response)
      if response.code == 200
        if response.headers['Content-Type'] == 'application/a-gzip'
          io = StringIO.new(response.body)
          gz = Zlib::GzipReader.new(io)
          return gz.readlines.join
        else
          doc = Nokogiri::XML(response.body)
          return Hash.from_xml(doc.to_s)
        end
      end

      if mode == 'Robot.XML'
        doc = Nokogiri::XML(response.body)
        return Hash.from_xml(doc.to_s)
      end

      return response.body
    end
  end
end
