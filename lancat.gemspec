lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lancat/version'

Gem::Specification.new do |s|
  s.name        = 'lancat'
  s.version     = Lancat::VERSION
  s.summary     = 'Zero-configuration LAN file transfer'
  s.description = 'lancat is a program which allows files and other data to ' \
                  'be quickly transferred over the local network by piping ' \
                  'data into lancat in the shell on one machine, and out of ' \
                  'lancat in the shell at another machine. It uses multicast ' \
                  'so no configuration (e.g. of IP addresses) needs to take ' \
                  'place.'
  s.license     = 'ISC'
  s.author      = 'Graham Edgecombe'
  s.email       = 'graham@grahamedgecombe.com'
  s.homepage    = 'http://grahamedgecombe.com/projects/lancat'
  s.files       = Dir['{bin/lancat,lib/lancat.rb,lib/lancat/*.rb}']
  s.executables = 'lancat'
end
