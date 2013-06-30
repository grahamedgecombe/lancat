Gem::Specification.new do |s|
  s.name        = 'lancat'
  s.version     = '0.0.1'
  s.summary     = 'Zero-configuration LAN file transfer'
  s.author      = 'Graham Edgecombe'
  s.email       = 'graham@grahamedgecombe.com'
  s.homepage    = 'http://grahamedgecombe.com/projects/lancat'
  s.files       = Dir['{bin/lancat,lib/lancat.rb,lib/lancat/*.rb}']
  s.executables = 'lancat'
end
