require 'spec_helper'

describe 'AppleReporter.Finance' do
  let(:endpoint) { 'https://reportingitc-reporter.apple.com/reportservice/finance/v1'}
  let(:reporter) { AppleReporter::Finance.new(user_id: 'iscreen', access_token: 'your access token') }

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

  describe '#accounts' do
    describe 'successfully' do
      let(:accounts_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'accounts.xml')) }
      before do
        stub_request(:post, endpoint)
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
      let(:error_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }
      before do
        stub_request(:post, endpoint)
          .to_return(status: 400, body: error_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get errors' do
        report = reporter.accounts
        expect(report.key?('Error')).to be(true)
        expect(report['Error'].key?('Code')).to be(true)
      end
    end
  end

  describe '#vendors_and_regions' do
    describe 'successfully' do
      let(:vendors_and_regions_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'vendors_and_regions.xml')) }
      before do
        stub_request(:post, endpoint)
          .with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 200, body: vendors_and_regions_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'sends getReport with the correct parameters' do
        report = reporter.vendors_and_regions
        expect(report.key?('VendorsAndRegions')).to be(true)
        expect(report['VendorsAndRegions'].key?('Vendor')).to be(true)
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
          vendor_number: 'myVendor',
          report_type: 'Sales',
          report_sub_type: 'Summary',
          date_type: 'Daily',
          date: '20161212'
        )
        expect(report.key?('Error')).to be(true)
      end
    end
  end

  describe '#get_report' do
    describe 'successfully' do
      let(:report_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'finance_reports.xml')) }
      let(:gz_report) { ActiveSupport::Gzip.compress(report_fixture) }
      before do
        stub_request(:post, endpoint)
          .with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 200, body: gz_report, headers: { 'Content-Type' => 'application/a-gzip'})
      end

      it 'sends getReport with the correct parameters' do
        report = reporter.get_report(
          vendor_number: 'myVendor',
          region_code: 'US',
          report_type: 'Financial',
          fiscal_year: '2016',
          fiscal_period: '02'
        )
        expect(report_fixture).to match(/^Start Date\tEnd Date/)
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
          vendor_number: 'myVendor',
          region_code: 'US',
          report_type: 'Financial',
          fiscal_year: '2016',
          fiscal_period: '02'
        )
        expect(report.key?('Error')).to be(true)
      end
    end
  end
end
