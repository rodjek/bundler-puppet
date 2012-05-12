Gem::Specification.new do |s|
  s.name = 'bundler-puppet'
  s.version = '0.0.1'
  s.authors = ['Tim Sharpe', 'Mick Pollard']
  s.email = ['tim@sharpe.id.au', 'aussielunix@gmail.com']
  s.homepage = 'https://github.com/rodjek/bundler-puppet'
  s.summary = 'Puppet support for bundler'
  s.description = <<-EOF
    Add support to bundler so that it can manage Puppet modules from git &
    the forge.
  EOF
  s.files = ['lib/bundler/puppet.rb', 'bin/pundle']
  s.executables = ['pundle']
  s.add_dependency 'bundler'
end
