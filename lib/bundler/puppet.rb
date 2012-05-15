require 'bundler'

module Bundler
  module Puppet
    module DslPatch
      def git_puppet(uri, options = {}, source_options = {}, &blk)
        source ::Bundler::Puppet::Source::Git.new(_normalize_hash(options).merge("uri" => uri)), source_options, &blk
      end

      def self.included(mod)
        mod.send :alias_method, :git_non_puppet, :git
        mod.send :alias_method, :git, :git_puppet
      end
    end

    module SettingsPatch
      def path_puppet
        key = key_for(:path)
        path = ENV[key] || @global_config[key]
        return path if path && !@local_config.key?(key)

        if path = self[:path]
          path
        else
          'modules'
        end
      end

      def self.included(mod)
        mod.send :alias_method, :path_non_puppet, :path
        mod.send :alias_method, :path, :path_puppet
      end
    end

    module Source
      class Git < ::Bundler::Source::Git
        def install_path
          begin
            git_scope = find_modulename(base_name)

            if Bundler.requires_sudo?
              Bundler.user_bundle_path.join(Bundler.ruby_scope).join(git_scope)
            else
              Bundler.install_path.join(git_scope)
            end
          end
        end

        alias :path :install_path
      private
        def find_modulename(str)
          if str =~ /-puppet$/
            part = 1
          else
            part = 2
          end

          str.split(/\A([^-\/|.]+)[-|\/](.+)\z/)[part]
        end
      end
    end
  end

  Bundler::Dsl.send(:include, Bundler::Puppet::DslPatch)
  Bundler::Settings.send(:include, Bundler::Puppet::SettingsPatch)

  class << self
    def home
      bundle_path
    end

    def install_path
      home
    end

    def cache
      bundle_path.join(".cache/bundler")
    end
  end
end
