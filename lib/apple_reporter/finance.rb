module AppleReporter
  class Finance < Reporter
    # accounts
    #
    # Usage:
    #   report = reporter.accounts
    def accounts
      fetch(@config[:finance_path], 'Finance.getAccounts')
    end

    # status
    #
    # Usage:
    #   report = reporter.status
    def status
      fetch(@config[:finance_path], 'Finance.getStatus')
    end

    # vendors_and_regions
    #
    # Usage:
    #   report = reporter.vendors_and_regions
    def vendors_and_regions
      fetch(@config[:finance_path], 'Finance.getVendorsAndRegions')
    end

    # get_report
    # Refer to: https://help.apple.com/itc/appsreporterguide/
    #
    # Usage:
    #
    # report = reporter.get_report(
    #   vendor_number: 'myVendor',
    #   region_code: 'US',
    #   report_type: 'Financial',
    #   fiscal_year: '2016',
    #   fiscal_period: '02'
    # )
    def get_report(params = {})
      fetch(@config[:finance_path], (['Finance.getReport'] + [params.slice(:vendor_number, :region_code, :report_type, :fiscal_year, :fiscal_period).values.join(',')]).join(', '))
    end

    def version
      @config[:version]
    end
  end
end
