require 'bundler'

module Bundler
  module Puppet
    module DslPatch
      def git_puppet(uri, options = {}, source_options = {}, &blk)
        puts "Woot"
        source Source::Git.new(_normalize_hash(options).merge("uri" => uri)), source_options, &blk
      end

      def self.included(mod)
        mod.send :alias_method, :git_non_puppet, :git
        mod.send :alias_method, :git, :git_puppet
      end
    end
  end

  Bundler::Dsl.send(:include, Bundler::Puppet::DslPatch)
end
