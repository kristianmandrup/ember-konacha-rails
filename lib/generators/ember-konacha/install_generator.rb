require 'net/http'

module EmberKonacha
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option  :sinon_version, type: :string, default: '1.6',
                    desc:   'Sinon version to get',
                    banner: 'Sinon version'

      class_option  :driver, type: :string, default: 'poltergeist',
                    desc:   'Javascript driver to use',
                    banner: 'Javascript driver'

      class_option  :with_index, type: :boolean, default: false,
                    desc:   'Generate default view files for single page app',
                    banner: 'Generate html view (index.html)'


      def do_validations
        validate_driver! 
      end

      def add_gems
        gem_group :development, :test do
          gem "konacha"
          gem js_driver
        end

        say "Note: You must install PhantomJS, f.ex using homebrew"
      end

      def create_infra_files
        infra_files.each do |name|
          coffee_template name
        end
      end

      def create_vendor_files
        vendor("assets/javascripts/sinon.js") do
          get_remote_file :sinon, option[:sinon_version]
        end
      rescue
        say "Sinon URI access/download error! Using Sinon-1.6 supplied by the generator gem ;)"
        template 'sinon.js', 'vendor/assets/javascripts/sinon.js'
      end

      def create_spec_files
        spec_files.each do |name|
          spec_template name
        end
      end

      def add_pre
        return unless File.exist? Rails.root.join(coffee_manifest_file)

        # ensure App is prefixed with window namespace!
        gsub_file coffee_manifest_file, /[^\.]App =/ do |match|
          match << "window.App ="
        end        

        append_to_file coffee_manifest_file do
          'App.deferReadiness()'
        end
      end

      def create_view_files
        return unless option[:with_index]
        
        copy_file 'spec/views/layouts/application.html.slim', 'app/views/layouts/application.html.slim'
        copy_file 'spec/views/application/index.html.slim', 'app/views/application/index.html.slim'
      end

      protected

      def coffee_manifest_file
        'app/assets/javascripts/application.js.coffee'
      end

      def validate_driver! 
        unless valid_driver?
          raise "Invalid javascript driver #{js_driver}, must be one of: #{valid_drivers}"  
        end
      end

      def js_driver
        options[:driver] || 'poltergeist'
      end

      def valid_driver? name
        valid_drivers.include? name.to_s
      end

      def valid_drivers
        %w{poltergeist selenium}
      end

      def spec_template name
        src_file = File.join 'specs/app', name
        target_file = File.join 'app', name
        template coffee_filename, coffee_target_file(name)
      end

      def spec_files
        [:store_spec, :router_spec]
      end      

      def get_remote_file name, version = nil    
        url = version_it remote_uri(name.to_sym), version
        uri = URI url
        Net::HTTP.get uri
      end

      def version_it uri, version = nil
        return uri if !version
        uri.sub /VERSION/, version
      end

      def remote_uri
        {
          sinon: 'http://sinonjs.org/releases/sinon-VERSION.js'
        }
      end

      def infra_files
        [:spec_helper, :konacha_config]
      end

      def coffee_template name
        template coffee_filename(name), coffee_target_file(name)
      end

      def js_template name
        template js_filename(name), js_target_file(name)
      end

      def js_target_file name
        File.join 'spec/javascripts', js_filename(target name)
      end

      def coffee_target_file name
        File.join 'spec/javascripts', coffee_filename(target name)
      end

      def resolve_target name
        resolve_map(name.to_sym) || name
      end

      def resolve_map
        {
          sinon_mvc_mocks: 'support/sinon_mvc_mocks',
          konacha_config: 'support/konacha_config'
        }
      end

      def js_filename name
        "#{name}.js"
      end

      def coffee_filename name
        "#{name}.js.coffee"
      end
    end
  end
end