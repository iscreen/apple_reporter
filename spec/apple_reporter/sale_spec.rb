require 'spec_helper'

describe 'AppleReporter.Sale' do

  let(:reporter) { AppleReporter::Sale.new(user_id: 'iscreen', password: 'your password') }

  describe '#getAccounts' do
    describe 'successfully' do
      let(:accounts_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'accounts.xml')) }
      before do
        stub_request(:post, 'https://reportingitc-reporter.apple.com/reportservice/sales/v1').
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
      let(:accounts_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }
      before do
        stub_request(:post, 'https://reportingitc-reporter.apple.com/reportservice/sales/v1').
          with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).
          to_return(status: 400, body: accounts_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get errors' do
        report = reporter.getAccounts
        expect(report.key?('Error')).to be(true)
        expect(report['Error'].key?('Code')).to be(true)
      end
    end
  end

  describe '#getStatus' do
    describe 'successfully' do
      let(:status_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'status.xml')) }
      before do
        stub_request(:post, 'https://reportingitc-reporter.apple.com/reportservice/sales/v1').
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
        stub_request(:post, 'https://reportingitc-reporter.apple.com/reportservice/sales/v1').
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

  describe '#getVendors' do
    describe 'successfully' do
      let(:vendors_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'vendors.xml')) }
      before do
        stub_request(:post, 'https://reportingitc-reporter.apple.com/reportservice/sales/v1').
          with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).
          to_return(status: 200, body: vendors_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get vendors results' do
        report = reporter.getVendors
        expect(report.key?('Vendors')).to be(true)
        expect(report['Vendors'].key?('Vendor')).to be(true)
      end
    end

    describe 'failure' do
      let(:error_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }
      before do
        stub_request(:post, 'https://reportingitc-reporter.apple.com/reportservice/sales/v1').
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

  describe '#getReport' do
    describe 'successfully' do
      let(:report_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'reports.csv')) }
      let(:gz_report) { Tempfile.new('iscreen') }
      let!(:report) do
        Zlib::GzipWriter.open(gz_report.path) do |gz|
          gz.write report_fixture
        end
      end

      before do
        stub_request(:post, 'https://reportingitc-reporter.apple.com/reportservice/sales/v1').
          with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }).
          to_return(status: 200, body: File.read(gz_report.path), headers: { 'Content-Type' => 'application/a-gzip'})
      end

      it 'sends getReport with the correct parameters' do
        report = reporter.getReport(
          {
            vendor_number: 'myVendor',
            report_type: 'Sales',
            report_sub_type: 'Summary',
            date_type: 'Daily',
            date: '20161212'
          }
        )
        expect(report).to match(/^Provider\tProvider Country/)
      end
    end

    describe 'failure' do
      let(:error_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }

      before do
        stub_request(:post, 'https://reportingitc-reporter.apple.com/reportservice/sales/v1').
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
end
