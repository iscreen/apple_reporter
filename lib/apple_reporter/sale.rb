module AppleReporter
  class Sale < Reporter
    # accounts
    #
    # Usage:
    #   report = reporter.accounts
    def accounts
      fetch(@config[:sales_path], 'Sales.getAccounts')
    end

    # status
    #
    # Usage:
    #   report = reporter.status
    def status
      fetch(@config[:sales_path], 'Sales.getStatus')
    end

    # vendors
    #
    # Usage:
    #   report = reporter.vendors
    def vendors
      fetch(@config[:sales_path], 'Sales.getVendors')
    end

    def version
      @config[:version]
    end

    # get_report
    # Refer to: https://help.apple.com/itc/appsreporterguide/
    #
    # Usage:
    #
    # report = reporter.get_report(
    #   vendor_number: 'myVendor',
    #   report_type: 'Sales',
    #   report_sub_type: 'Summary',
    #   date_type: 'Daily',
    #   date: '20161212'
    # )
    def get_report(params = {})
      fetch(@config[:sales_path], (['Sales.getReport'] + [params.slice(:vendor_number, :report_type, :report_sub_type, :date_type, :date).values.join(',')]).join(', '))
    end
  end
end
