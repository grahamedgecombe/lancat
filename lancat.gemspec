Gem::Specification.new do |s|
  s.name        = 'lancat'
  s.version     = '0.0.1'
  s.summary     = 'Zero-configuration LAN file transfer'
  s.description = 'lancat is a program which allows files and other data to ' \
                  'be quickly transferred over the local network by piping ' \
                  'data into lancat in the shell at one end, and out of ' \
                  'lancat at the other end. It uses multicast so no ' \
                  'configuration (e.g. of IP addresses) needs to take place.'
  s.license     = 'ISC'
  s.author      = 'Graham Edgecombe'
  s.email       = 'graham@grahamedgecombe.com'
  s.homepage    = 'http://grahamedgecombe.com/projects/lancat'
  s.files       = Dir['{bin/lancat,lib/lancat.rb,lib/lancat/*.rb}']
  s.executables = 'lancat'
end
