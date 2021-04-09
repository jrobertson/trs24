Gem::Specification.new do |s|
  s.name = 'trs24'
  s.version = '0.1.1'
  s.summary = 'Accepts a list of activty times and returns a summary of activity duration.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/trs24.rb']
  s.add_runtime_dependency('subunit', '~> 0.8', '>=0.8.3')
  s.add_runtime_dependency('dynarex', '~> 1.8', '>=1.8.27')
  s.add_runtime_dependency('mindwords', '~> 0.5', '>=0.5.7')
  s.signing_key = '../privatekeys/trs24.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/trs24'
end
