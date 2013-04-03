module EmberKonacha
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option  :sinon, type: :string, default: '1.6.0',
                    desc:   'Sinon version to get',
                    banner: 'Sinon version'

      class_option  :driver, type: :string, default: 'poltergeist',
                    desc:   'Javascript driver to use',
                    banner: 'Javascript driver'

      class_option  :with_index, type: :boolean, default: false,
                    desc:   'Generate default view files for single page app',
                    banner: 'Generate html view (index.html)'

      source_root File.expand_path('../templates', __FILE__)

      def do_validations
        validate_driver!
        validate_sinon_version! 
      end

      def add_gems        
        unless has_gem? 'konacha'
          gem 'konacha', group: [:development, :test] 
        end

        has_gem?(js_driver) ? skip_driver : gem(js_driver, group: [:development, :test])

        unless has_gem?('coffee-rails') || !coffee?
          gem 'coffee-rails'
        end
      end

      def create_infra_files
        infra_files.each do |name|
          begin
            coffee_template name
          rescue
            js_template name
          end            
        end        
      end

      def create_vendor_files
        return if has_sinon_file?

        require 'httparty'

        sinon_content = get_remote_file :sinon, sinon_version

        puts "write sinon: #{sinon_content}"

        unless sinon_content.blank?
          say "Sinon js empty!", :red
          exit
        end

        vendor(sinon_path, sinon_content)

      rescue Exception => e
        say e.message, :red
        say %Q{Sinon URI access/download error: #{@uri}. 
Using sinon-1.6.js supplied by this gem ;)}
        template 'vendor/sinon.js', 'vendor/assets/javascripts/sinon.js'
      end

      def create_spec_files
        spec_files.each do |name|
          spec_template name
        end
      end

      def add_pre
        return unless has_file? Rails.root.join(coffee_manifest_file)

        # ensure App is prefixed with window namespace!
        gsub_file coffee_manifest_file, /[^\.]App =/ do |match|
          match << "window.App ="
        end        

        append_to_file coffee_manifest_file do
          'App.deferReadiness()'
        end
      end

      def create_view_files
        return unless with_index?
        
        copy_file 'spec/views/layouts/application.html.slim', 'app/views/layouts/application.html.slim'
        copy_file 'spec/views/application/index.html.slim', 'app/views/application/index.html.slim'
      end


      def post_install_notice
        return if skipped_driver?

        say nice(js_driver_notice) , :green
      end

      protected

      def skip_driver
        @skipped_driver = true
      end

      def skipped_driver?
        @skipped_driver
      end

      def nice text
        border + text
      end

      def border width = 80
        @border ||= "=" * width + "\n"
      end

      def coffee?
        true
      end

      def has_sinon_file?
        @has_sinon ||= has_file? sinon_file_path
      end

      def has_file? path
        File.exist?(path) && !blank_file?(sinon_file_path)
      end

      def blank_file? path
        File.open(path).read.blank?
      end

      def sinon_file_path
        Rails.root.join('vendor', sinon_path)
      end

      def sinon_path
        "assets/javascripts/sinon.js"
      end

      def js_driver_notice 
        case js_driver.to_sym
        when :poltergeist
           %q{Note: poltergeist requires you have installed PhantomJS headless JS driver. 

via Homebrew: 

brew install phantomjs

MacPorts: 

sudo port install phantomjs

See https://github.com/jonleighton/poltergeist
}
        else
          %q{Note: Install a suitable Javascript driver for headless js testing.

Google V8: 

gem install therubyracer

Mozilla Rhino (JRuby only) : 

gem install therubyrhino
}
        end
      end

      def has_gem? name
        gemfile_content =~ /gem\s+('|")#{name}/
      end

      def gemfile_content
        @gemfile_content ||= gemfile.read
      end

      def gemfile
        @gemfile ||= File.open Rails.root.join('Gemfile'), 'r'
      end

      def sinon_version
        @sinon_version ||= options[:sinon]
      end

      def validate_sinon_version!
        unless sinon_version =~ /\d\.\d\.\d/
          say "Invalid sinon version format, must be of the form: x.y.z, f.ex 1.5.2, was: #{sinon_version}", :red
        end
      end

      def with_index?
        options[:with_index]
      end

      def coffee_manifest_file
        'app/assets/javascripts/application.js.coffee'
      end

      def validate_driver! 
        unless valid_driver? js_driver
          say "Invalid javascript driver #{js_driver}, must be one of: #{valid_drivers}" , :red
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
        src_file = File.join 'specs/app', name.to_s
        target_file = File.join 'app', name.to_s
        template coffee_filename(src_file), coffee_target_file(target_file)      
      end

      def spec_files
        [:store_spec, :router_spec]
      end      

      def get_remote_file name, version = nil    
        url = version_it remote_uri[name.to_sym], version
        @uri = URI url
        say "Trying to download sinon.js (#{@uri}) ..."
        response = HTTParty.get @uri

        puts response.inspect

        response.code != "404" ? result.body : nil
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
        [:spec_helper, :konacha_config, :sinon_mvc_mocks]
      end

      def coffee_template name
        template coffee_filename(name), coffee_target_file(name)
      end

      def js_template name
        template js_filename(name), js_target_file(name)
      end

      def js_target_file name
        File.join 'spec/javascripts', js_filename(resolved_target name)
      end

      def coffee_target_file name
        File.join 'spec/javascripts', coffee_filename(resolved_target name)
      end

      def resolved_target name
        resolve_map[name.to_sym] || name
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