#!/usr/bin/ruby

require 'rubygems'
require 'openssl'
require 'socket'
require 'cgi'

    device = [ARGV[0]]
 
    socket = TCPSocket.new('gateway.sandbox.push.apple.com',2195)
 
    context = OpenSSL::SSL::SSLContext.new('SSLv3')
    context.cert = OpenSSL::X509::Certificate.new(File.read('/home/monaos/www/kingsear/apns-dev.pem'))
    context.key  = OpenSSL::PKey::RSA.new(File.read('/home/monaos/www/kingsear/apns-dev-key-noenc.pem'))
 
    ssl = OpenSSL::SSL::SSLSocket.new(socket, context)
    ssl.connect
 
    payload = <<-EOS
{
  "aps":{
    "alert":"#{CGI.unescape(ARGV[1])}",
    "badge":1,
    "sound":"default"
  }
}
EOS
    (message = []) << ['0'].pack('H') << [32].pack('n') << device.pack('H*') << [payload.size].pack('n') << payload
 
 
    ssl.write(message.join(''))
STDERR.puts message.join('')
    ssl.close
    socket.close
