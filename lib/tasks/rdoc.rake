# MDme Rails master application
# Author:: Matt Hamada (maito:mattahamada@gmail.com)
# 10/22/14
# Copyright:: Copyright (c) 2014 MDme
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential.

# Generates rdoc files
RDoc::Task.new :rdoc do |rdoc|
  rdoc.main = "README.rdoc"

  rdoc.rdoc_files.include("README.rdoc", "doc/*.rdoc", "app/**/*.rb", "lib/*.rb", "config/**/*.rb")
  #change above to fit needs

  rdoc.title = "App Documentation"
  rdoc.options << "--all"
end