Gem::Specification.new do |s|
	s.name        = 'idn'
	s.version     = '0.0.2'
	s.author      = 'Erik Abele'
	s.email       = 'erikabele@rubyforge.org'
	s.summary     = 'LibIDN Ruby Bindings'
	s.description = <<EOF
Ruby Bindings for the GNU LibIDN library, an implementation of the
Stringprep, Punycode and IDNA specifications defined by the IETF
Internationalized Domain Names (IDN) working group.

Included are the most important parts of the Stringprep, Punycode
and IDNA APIs like performing Stringprep processings, encoding to
and decoding from Punycode strings and converting entire domain names
to and from the ACE encoded form.
EOF

	s.rubyforge_project = s.name
	s.homepage = 'http://rubyforge.org/projects/idn/'

	s.files = Dir.glob('{ext,lib,test}/**/*.{c,h,rb}') + %w(README CHANGES LICENSE NOTICE Rakefile)

	s.extensions = [ 'ext/extconf.rb' ]

	s.require_path = 'lib'

	s.test_files = Dir.glob('test/ts_*.rb')

	s.has_rdoc = true
	s.extra_rdoc_files = Dir.glob('lib/**/*.rb') + %w(README CHANGES LICENSE
		ext/idna.c ext/punycode.c ext/stringprep.c ext/idn.c)

	s.rdoc_options << '-m' << 'README' <<
										'-t' << 'LibIDN Ruby Bindings Documentation' <<
										'-N' << '-S' << '-w 2'
end
