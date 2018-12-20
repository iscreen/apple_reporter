require 'spec_helper'

describe 'AppleReporter.Sale' do
  let(:endpoint) { 'https://reportingitc-reporter.apple.com/reportservice/sales/v1'}
  let(:reporter) { AppleReporter::Sale.new(user_id: 'iscreen', access_token: 'your access token') }

  describe '#accounts' do
    describe 'successfully' do
      let(:accounts_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'accounts.xml')) }
      before do
        stub_request(:post, 'https://reportingitc-reporter.apple.com/reportservice/sales/v1')
          .with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 200, body: accounts_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get accounts' do
        report = reporter.accounts
        expect(report.key?('Accounts')).to be(true)
        expect(report['Accounts'].key?('Account')).to be(true)
      end
    end

    describe 'failure' do
      let(:accounts_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }
      before do
        stub_request(:post, endpoint)
          .to_return(status: 400, body: accounts_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get errors' do
        report = reporter.accounts
        expect(report.key?('Error')).to be(true)
        expect(report['Error'].key?('Code')).to be(true)
      end
    end
  end

  describe '#status' do
    describe 'successfully' do
      let(:status_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'status.xml')) }
      before do
        stub_request(:post, endpoint)
          .with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 200, body: status_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get status results' do
        report = reporter.status
        expect(report.key?('Status')).to be(true)
        expect(report['Status'].key?('Code')).to be(true)
      end
    end

    describe 'failure' do
      let(:error_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }
      before do
        stub_request(:post, endpoint)
          .with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 400, body: error_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get errors' do
        report = reporter.status
        expect(report.key?('Error')).to be(true)
        expect(report['Error'].key?('Code')).to be(true)
      end
    end
  end

  describe '#vendors' do
    describe 'successfully' do
      let(:vendors_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'vendors.xml')) }
      before do
        stub_request(:post, endpoint)
          .with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 200, body: vendors_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get vendors results' do
        report = reporter.vendors
        expect(report.key?('Vendors')).to be(true)
        expect(report['Vendors'].key?('Vendor')).to be(true)
      end
    end

    describe 'failure' do
      let(:error_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }
      before do
        stub_request(:post, endpoint)
          .with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 400, body: error_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get errors' do
        report = reporter.status
        expect(report.key?('Error')).to be(true)
        expect(report['Error'].key?('Code')).to be(true)
      end
    end
  end

  describe '#get_report' do
    describe 'successfully' do
      let(:report_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'reports.csv')) }
      let(:gz_report) { ActiveSupport::Gzip.compress(report_fixture) }

      before do
        stub_request(:post, endpoint)
          .with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 200, body: gz_report, headers: { 'Content-Type' => 'application/a-gzip'})
      end

      it 'sends get_report with the correct parameters' do
        report = reporter.get_report(
          {
            vendor_number: 'myVendor',
            report_type: 'Sales',
            report_sub_type: 'Summary',
            date_type: 'Daily',
            date: '20161212'
          }
        )
        expect(report_fixture).to match(/^Provider\tProvider Country/)
      end
    end

    describe 'failure' do
      let(:error_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }

      before do
        stub_request(:post, endpoint)
          .with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 400, body: error_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get errors' do
        report = reporter.get_report(
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
