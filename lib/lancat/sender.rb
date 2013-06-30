require 'socket'
require 'lancat/addr'

module Lancat
  class Sender
    def initialize(verbose, timeout, input)
      @verbose = verbose
      @timeout = timeout
      @input = input
    end

    def start
      server = TCPServer.new(0)
      begin
        _, port, _, _ = server.addr(:numeric)

        STDERR.puts "Listening on port #{port}..." if @verbose

        # keep broadcasting packet indicating our IP/port, stop after timeout
        # or after a connection arrives
        client = nil
        multicast_sock = UDPSocket.new(Socket::AF_INET)
        begin
          multicast_sock.setsockopt(Socket::IPPROTO_IP, Socket::IP_MULTICAST_LOOP, [1].pack('i'))
          multicast_sock.setsockopt(Socket::IPPROTO_IP, Socket::IP_TTL, [1].pack('i'))

          msg = [port].pack('S>')

          for i in 1..@timeout
            STDERR.puts "Broadcast attempt #{i}..." if @verbose
            multicast_sock.send(msg, 0, MULTICAST_ADDR, MULTICAST_PORT)
            sleep 1

            begin
              client = server.accept_nonblock
              break if not client.nil?
            rescue IO::WaitReadable
              # ignore
            end
          end
        ensure
          multicast_sock.close
        end

        abort 'lancat: Timeout' if client.nil?

        _, _, _, remote = client.peeraddr(:numeric)
        STDERR.puts "Connection from #{remote}, writing data..." if @verbose

        loop do
          begin
            data = @input.readpartial(4096)
            client.write(data)
          rescue EOFError
            break
          end
        end
      ensure
        server.close
      end

      STDERR.puts 'Transfer complete.' if @verbose
    end
  end
end
