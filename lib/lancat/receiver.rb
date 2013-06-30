require 'socket'
require 'ipaddr'

module Lancat
  class Receiver
    def initialize(verbose, timeout, output)
      @verbose = verbose
      @timeout = timeout
      @output = output
    end

    def start
      STDERR.puts 'Waiting for broadcasts...' if @verbose

      addr = nil
      port = nil

      # wait for multicast packet to find the port number/IP address of the
      # other end
      multicast_sock = UDPSocket.new(Socket::AF_INET)
      begin
        ips = IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new('0.0.0.0').hton
        multicast_sock.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP, ips)
        multicast_sock.bind(Socket::INADDR_ANY, MULTICAST_PORT)

        # TODO add support for receive timeout
        msg, addr = multicast_sock.recvfrom(2)
        port = msg.unpack('S>')[0]
        addr = addr[3]
      ensure
        multicast_sock.close
      end

      # connect to that IP/port over TCP, read until EOF and write the data to
      # @output
      STDERR.puts "Connecting to #{addr}:#{port}..." if @verbose
      client = TCPSocket.new(addr, port)
      begin
        STDERR.puts 'Reading data...' if @verbose
        loop do
          begin
            data = client.readpartial(4096)
            @output.write(data)
          rescue EOFError
            break
          end
        end
      ensure
        client.close
      end

      STDERR.puts 'Transfer complete.' if @verbose
    end
  end
end
