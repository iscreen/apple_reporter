module AppleReporter
  class Sale < Reporter

    # getAccounts
    #
    # Usage:
    #   report = reporter.getAccounts
    def getAccounts
      fetch(@config[:sales_path], 'Sales.getAccounts')
    end

    # getStatus
    #
    # Usage:
    #   report = reporter.getStatus
    def getStatus
      fetch(@config[:sales_path], 'Sales.getStatus')
    end

    # getVendors
    #
    # Usage:
    #   report = reporter.getVendors
    def getVendors
      fetch(@config[:sales_path], 'Sales.getVendors')
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
      fetch(@config[:sales_path], (['Sales.getReport'] + [params.slice(:vendor_number, :report_type, :report_sub_type, :date_type, :date).values.join(',')]).join(', '))
    end

  end
end
