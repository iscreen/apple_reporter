require 'spec_helper'

describe 'AppleReporter.Token' do
  let(:endpoint) { 'https://reportingitc-reporter.apple.com/reportservice/sales/v1'}
  let(:reporter) { AppleReporter::Token.new(user_id: 'iscreen', password: 'your password') }

  describe '#view' do
    describe 'successfully' do
      let(:view_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'view_token.xml')) }
      before do
        stub_request(:post, 'https://reportingitc-reporter.apple.com/reportservice/sales/v1')
          .with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 200, body: view_fixture, 
                     headers: { 'Content-Type' => 'text/plain;charset=utf-8', 'Service-Request-ID' => 'aaa-bbb'})
      end

      it 'get access token info' do
        report = reporter.view
        expect(report.key?('ViewToken')).to be(true)
        expect(report['ViewToken'].key?('AccessToken')).to be(true)
        expect(report['ViewToken'].key?('ExpirationDate')).to be(true)
      end
    end

    describe 'failure' do
      let(:view_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }
      before do
        stub_request(:post, endpoint)
          .to_return(status: 400, body: view_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get errors' do
        report = reporter.view
        expect(report.key?('Error')).to be(true)
        expect(report['Error'].key?('Code')).to be(true)
      end
    end
  end

  describe '#generate' do
    describe 'successfully' do
      let(:generate_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'generate_token.xml')) }
      before do
        stub_request(:post, 'https://reportingitc-reporter.apple.com/reportservice/sales/v1')
          .with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
          .to_return(status: 200, body: generate_fixture, 
                     headers: { 'Content-Type' => 'text/plain;charset=utf-8', 'Service-Request-ID' => 'aaa-bbb'})
      end

      it 'get NEW access token info' do
        report = reporter.view
        expect(report.key?('ViewToken')).to be(true)
        expect(report['ViewToken'].key?('AccessToken')).to be(true)
        expect(report['ViewToken'].key?('ExpirationDate')).to be(true)
        expect(report['ViewToken'].key?('Message')).to be(true)
        expect(report['ViewToken']['Message']).to eq("Your new access token has been generated.")
      end
    end

    describe 'failure' do
      let(:generate_fixture) { File.read(File.join(__dir__, '../', 'fixtures', 'error.xml')) }
      before do
        stub_request(:post, endpoint)
          .to_return(status: 400, body: generate_fixture, headers: { 'Content-Type' => 'text/plain;charset=utf-8'})
      end

      it 'get errors' do
        report = reporter.view
        expect(report.key?('Error')).to be(true)
        expect(report['Error'].key?('Code')).to be(true)
      end
    end
  end

end
