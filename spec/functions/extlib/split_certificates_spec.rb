require 'spec_helper'
require 'openssl'

describe 'extlib::split_certificates' do
  it 'exists' do
    is_expected.not_to eq(nil)
  end

  describe 'ca.pem' do
    let(:function_result) { subject.execute(File.expand_path('../../fixtures/ca.pem', File.dirname(__FILE__))) }

	  it 'returns an array' do
      expect(function_result).to be_kind_of Array
    end
    it 'returns 2 certificates' do
      expect(function_result.size).to eq(2)
    end
    it 'first certificate is signing cert' do
      cert = OpenSSL::X509::Certificate.new function_result[0]
      expect(cert.subject.to_s).to match(/CA signing cert/)
    end
    it 'second certificate is root ca' do
      cert = OpenSSL::X509::Certificate.new function_result[1]
      expect(cert.subject.to_s).to match(/CN=Puppet Root CA/)
    end
  end
end
