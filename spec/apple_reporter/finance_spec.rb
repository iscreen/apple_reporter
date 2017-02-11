require 'spec_helper'

describe 'AppleReporter.Finance' do
  let(:endpoint) { 'https://reportingitc-reporter.apple.com/reportservice/finance/v1'}
  let(:reporter) { AppleReporter::Finance.new(user_id: 'iscreen', password: 'your password') }

  describe '#getStatus' do
    describe 'successfully' do
      let(:status_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'status.xml')) }
      before do
        stub_request(:post, endpoint).
          with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).
          to_return(status: 200, body: status_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get status results' do
        report = reporter.getStatus
        expect(report.key?('Status')).to be(true)
        expect(report['Status'].key?('Code')).to be(true)
      end
    end

    describe 'failure' do
      let(:error_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }
      before do
        stub_request(:post, endpoint).
          with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).
          to_return(status: 400, body: error_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get errors' do
        report = reporter.getStatus
        expect(report.key?('Error')).to be(true)
        expect(report['Error'].key?('Code')).to be(true)
      end
    end
  end

  describe '#getAccounts' do
    describe 'successfully' do
      let(:accounts_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'accounts.xml')) }
      before do
        stub_request(:post, endpoint).
          with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).
          to_return(status: 200, body: accounts_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get Accounts' do
        report = reporter.getAccounts
        expect(report.key?('Accounts')).to be(true)
        expect(report['Accounts'].key?('Account')).to be(true)
      end
    end

    describe 'failure' do
      let(:error_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }
      before do
        stub_request(:post, endpoint).
          #with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).
          to_return(status: 400, body: error_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get errors' do
        report = reporter.getAccounts
        expect(report.key?('Error')).to be(true)
        expect(report['Error'].key?('Code')).to be(true)
      end
    end
  end

  describe '#getVendorsAndRegions' do
    describe 'successfully' do
      let(:vendors_and_regions_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'vendors_and_regions.xml')) }
      before do
        stub_request(:post, endpoint).
          with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).
          to_return(status: 200, body: vendors_and_regions_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'sends getReport with the correct parameters' do
        report = reporter.getVendorsAndRegions
        expect(report.key?('VendorsAndRegions')).to be(true)
        expect(report['VendorsAndRegions'].key?('Vendor')).to be(true)
      end
    end

    describe 'failure' do
      let(:error_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }

      before do
        stub_request(:post, endpoint).
          with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).
          to_return(status: 400, body: error_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get errors' do
        report = reporter.getReport(
          {
            vendor_number: 'myVendor',
            report_type: 'Sales',
            report_sub_type: 'Summary',
            date_type: 'Daily',
            date: '20161212'
          }
        )
        expect(report.key?('Error')).to be(true)
      end
    end
  end

  describe '#getReport' do
    describe 'successfully' do
      let(:report_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'finance_reports.xml')) }
      let(:gz_report) { Tempfile.new('iscreen') }
      let!(:report) do
        Zlib::GzipWriter.open(gz_report.path) do |gz|
          gz.write report_fixture
        end
      end

      before do
        stub_request(:post, endpoint).
          with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).
          to_return(status: 200, body: File.read(gz_report.path), headers: { 'Content-Type' => 'application/a-gzip'})
      end

      it 'sends getReport with the correct parameters' do
        report = reporter.getReport(
          {
            vendor_number: 'myVendor',
            region_code: 'US',
            report_type: 'Financial',
            fiscal_year: '2016',
            fiscal_period: '02'
          }
        )
        expect(report).to match(/^Start Date\tEnd Date/)
      end
    end

    describe 'failure' do
      let(:error_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }

      before do
        stub_request(:post, endpoint).
          with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).
          to_return(status: 400, body: error_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get errors' do
        report = reporter.getReport(
          {
            vendor_number: 'myVendor',
            region_code: 'US',
            report_type: 'Financial',
            fiscal_year: '2016',
            fiscal_period: '02'
          }
        )
        expect(report.key?('Error')).to be(true)
      end
    end
  end

end