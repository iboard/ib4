# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scrooge}
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lourens Naud\303\251", "Stephen Sykes"]
  s.date = %q{2009-03-22}
  s.description = %q{An ActiveRecord attribute tracker to ensure production Ruby applications only fetch the database content needed to minimize wire traffic and reduce conversion overheads to native Ruby types.}
  s.email = %q{lourens@methodmissing.com or sdsykes@gmail.com}
  s.files = ["Rakefile", "README", "README.textile", "VERSION.yml", "lib/callsite.rb", "lib/optimizations", "lib/optimizations/associations", "lib/optimizations/associations/macro.rb", "lib/optimizations/columns", "lib/optimizations/columns/attributes_proxy.rb", "lib/optimizations/columns/macro.rb", "lib/optimizations/result_sets", "lib/optimizations/result_sets/result_array.rb", "lib/optimizations/result_sets/updateable_result_set.rb", "lib/scrooge.rb", "test/callsite_test.rb", "test/helper.rb", "test/models", "test/models/mysql_column_privilege.rb", "test/models/mysql_host.rb", "test/models/mysql_table_privilege.rb", "test/models/mysql_user.rb", "test/optimizations", "test/optimizations/associations", "test/optimizations/associations/macro_test.rb", "test/scrooge_helper.rb", "test/scrooge_test.rb", "test/setup.rb", "rails/init.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/methodmissing/scrooge}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Scrooge - Fetch exactly what you need}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
