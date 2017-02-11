module AppleReporter
  class Finance < Reporter

    # getAccounts
    #
    # Usage:
    #   report = reporter.getAccounts
    def getAccounts
      fetch(@config[:finance_path], 'Finance.getAccounts')
    end

    # getStatus
    #
    # Usage:
    #   report = reporter.getStatus
    def getStatus
      fetch(@config[:finance_path], 'Finance.getStatus')
    end

    # getVendorsAndRegions
    #
    # Usage:
    #   report = reporter.getVendorsAndRegions
    def getVendorsAndRegions
      fetch(@config[:finance_path], 'Finance.getVendorsAndRegions')
    end

    # getReport
    # Refer to: https://help.apple.com/itc/appsreporterguide/
    #
    # Usage:
    #
    # report = reporter.getReport(
    #   {
    #     vendor_number: 'myVendor',
    #     region_code: 'US',
    #     report_type: 'Financial',
    #     fiscal_year: '2016',
    #     fiscal_period: '02'
    #   }
    # )
    def getReport(params = {})
      fetch(@config[:finance_path], (['Finance.getReport'] + [params.slice(:vendor_number, :region_code, :report_type, :fiscal_year, :fiscal_period).values.join(',')]).join(', '))
    end

    def getVersion
      @config[:version]
    end
  end
end
