# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ec2-metadata}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Takeshi AKIMA"]
  s.date = %q{2010-04-09}
  s.default_executable = %q{ec2-metadata}
  s.description = %q{ec2-metadata provides to access metadata, and you can use in outside of ec2 like in ec2}
  s.email = %q{akm2000@gmail.com}
  s.executables = ["ec2-metadata"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/ec2-metadata",
     "ec2-metadata.gemspec",
     "lib/ec2_metadata.rb",
     "lib/ec2_metadata/base.rb",
     "lib/ec2_metadata/command.rb",
     "lib/ec2_metadata/dummy.rb",
     "lib/ec2_metadata/dummy.yml",
     "lib/ec2_metadata/http_client.rb",
     "lib/ec2_metadata/revision.rb",
     "lib/ec2_metadata/root.rb",
     "lib/hash_key_orderable.rb",
     "spec/ec2_metadata/base_spec.rb",
     "spec/ec2_metadata/command_spec.rb",
     "spec/ec2_metadata/dummy_spec.rb",
     "spec/ec2_metadata/http_client_spec.rb",
     "spec/ec2_metadata/revision_spec.rb",
     "spec/ec2_metadata/root_spec.rb",
     "spec/ec2_metadata_spec.rb",
     "spec/hash_key_orderable_spec.rb",
     "spec/introduction_spec.rb",
     "spec/rcov.opts",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/to_hash_spec.rb"
  ]
  s.homepage = %q{http://github.com/akm/ec2-metadata}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{ec2-metadata provides to access metadata}
  s.test_files = [
    "spec/ec2_metadata/base_spec.rb",
     "spec/ec2_metadata/command_spec.rb",
     "spec/ec2_metadata/dummy_spec.rb",
     "spec/ec2_metadata/http_client_spec.rb",
     "spec/ec2_metadata/revision_spec.rb",
     "spec/ec2_metadata/root_spec.rb",
     "spec/ec2_metadata_spec.rb",
     "spec/hash_key_orderable_spec.rb",
     "spec/introduction_spec.rb",
     "spec/spec_helper.rb",
     "spec/to_hash_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

