require 'openssl'

Puppet::Functions.create_function(:'extlib::split_certificates') do
  dispatch :split_cert_file do
    optional_param 'Stdlib::Absolutepath', :filename
    return_type 'Array[String[1]]'
  end

  dispatch :split_cert_string do
    param 'Pattern[/BEGIN CERTIFICATE/]', :string
    return_type 'Array[String[1]]'
  end

  def split_cert_file(filename = '/etc/puppetlabs/puppet/ssl/certs/ca.pem')
    split_cert_string(IO.binread(filename))
  end

  def split_cert_string(string)
    certs = []
    delimiter = "\n-----END CERTIFICATE-----\n"
    string.split(delimiter).each do |possible_cert|
      possible_cert.strip!
      possible_cert += delimiter
      begin
        cert = OpenSSL::X509::Certificate.new possible_cert
      rescue
        Puppet.debug('Skipping invalid certificate')
        next
      end
      certs << possible_cert
    end
    certs
  end
end
