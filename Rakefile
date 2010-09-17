# Rakefile for LibIDN Ruby Bindings.
#
# Copyright (c) 2005 Erik Abele. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# Please see the file called LICENSE for further details.
#
# You may also obtain a copy of the License at
#
# * http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This software is OSI Certified Open Source Software.
# OSI Certified is a certification mark of the Open Source Initiative.

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/contrib/sshpublisher'

begin
  require 'rubygems'
  require 'rake/gempackagetask'
rescue Exception
  nil
end

PKG_NAME = 'idn'
PKG_VERSION = '0.0.2'

PKG_AUTHOR = 'Erik Abele'
PKG_EMAIL = 'erikabele@rubyforge.org'

PKG_SUMMARY = 'LibIDN Ruby Bindings'

PKG_DESCRIPTION = <<-EOF
  Ruby Bindings for the GNU LibIDN library, an implementation of the
  Stringprep, Punycode and IDNA specifications defined by the IETF
  Internationalized Domain Names (IDN) working group.

  Included are the most important parts of the Stringprep, Punycode
  and IDNA APIs like performing Stringprep processings, encoding to
  and decoding from Punycode strings and converting entire domain names
  to and from the ACE encoded form.
EOF

PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

PKG_FILES = FileList[
  'README', 'CHANGES', 'LICENSE', 'NOTICE', 'Rakefile',
  'ext/**/*.{c,h,rb}', 'lib/**/*.rb', 'test/**/*.rb'
]

TEST_FILES = FileList[
  'test/ts_*.rb'
]

DOC_FILES = FileList[
  'README', 'CHANGES', 'LICENSE', 'lib/**/*.rb',
  'ext/idna.c', 'ext/punycode.c', 'ext/stringprep.c', 'ext/idn.c'
]

INFO_NOTE = <<EOL
  Please note that if the required libraries or header files can only be
  found in a non-standard location an alternative search path has to be
  specified when executing Rake:
    rake ext IDN_DIR=/path/to/non/standard/location
EOL

task :default do
  puts "Please see 'rake --tasks' for an overview of the available tasks."
end

desc 'Build all the extensions'
task :ext do
  extconf_args = ''

  unless ENV['IDN_DIR'].nil?
    extconf_args = "--with-idn-dir=#{ENV['IDN_DIR']}"
  end

  cd 'ext' do
    unless system("ruby extconf.rb #{extconf_args}")
      STDERR.puts "ERROR: could not configure extension!\n" +
                  "\n#{INFO_NOTE}\n"
      break
    end

    unless system('make')
      STDERR.puts 'ERROR: could not build extension!'
      break
    end
  end
end

desc 'Install (and build) extensions'
task :install => [:ext] do
  cd 'ext' do
    unless system('make install')
      STDERR.puts 'ERROR: could not install extension!'
      break
    end
  end
end

desc 'Remove extension products'
task :clobber_ext do
  FileList['ext/**/*'].each do |file|
    unless FileList['ext/**/*.{c,h,rb}'].include?(file)
      rm_r file if File.exists?(file)
    end
  end
end

desc 'Force a rebuild of the extension files'
task :reext => [:clobber_ext, :ext]

desc 'Remove all files created during the build process'
task :clobber => [:clobber_doc, :clobber_ext, :clobber_package]

Rake::TestTask.new do |test|
  test.test_files = TEST_FILES
  test.verbose = true
  test.warning = true
end

Rake::RDocTask.new('doc') do |rdoc|
  rdoc.rdoc_files = DOC_FILES
  rdoc.rdoc_dir = 'doc'
  rdoc.main = 'README'
  rdoc.title = "#{PKG_SUMMARY} Documentation"
  rdoc.options << '-N' << '-S' << '-w 2'
end

desc 'Publish the documentation'
task :publish_doc => [:redoc] do
  Rake::SshDirPublisher.new(PKG_EMAIL,
    "/var/www/gforge-projects/#{PKG_NAME}/docs", 'doc').upload
end

if defined?(Gem) 
  spec = Gem::Specification.new do |s|
    s.name = PKG_NAME
    s.version = PKG_VERSION
    s.author = PKG_AUTHOR
    s.email = PKG_EMAIL
    s.summary = PKG_SUMMARY
    s.description = PKG_DESCRIPTION

    s.rubyforge_project = s.name
    s.homepage = "http://rubyforge.org/projects/#{PKG_NAME}/"

    s.files = PKG_FILES.delete_if {|f| f.include?('CVS')}
    s.extensions = ['ext/extconf.rb']

    s.require_path = 'lib'
    s.autorequire = s.name

    s.test_files = TEST_FILES

    s.has_rdoc = true
    s.extra_rdoc_files = DOC_FILES
    s.rdoc_options << '-m' << 'README' <<
                      '-t' << "#{PKG_SUMMARY} Documentation" <<
                      '-N' << '-S' << '-w 2'
  end

  Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_zip = true
    pkg.need_tar_gz = true
  end
end
