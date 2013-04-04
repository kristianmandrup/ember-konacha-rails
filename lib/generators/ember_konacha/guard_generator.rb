require 'generators/ember_konacha/gem_helper'

module EmberKonacha
  module Generators
    class GuardGenerator < Rails::Generators::Base
      class_option  :driver, type: :string, default: 'poltergeist',
                    desc:   'Konacha JS driver to use',
                    banner: 'Konacha JS driver'

      TPL_PATH = File.expand_path('../templates', __FILE__)

      source_root TPL_PATH

      def add_guard_gem
        return if has_all_gems? 'guard', 'guard-konacha' 

        gem 'guard' unless has_gem? 'guard'
        gem 'guard-konacha' unless has_gem? 'guard-konacha'

        if driver == 'webkit'
          gem "capybara-webkit" unless has_gem? "capybara-webkit"
        end

        bundle_gems!

        say "Notice: Please move the gem statements just appended to the Gemfile into a [:test, :development] group", :green
      end

      def create_guardfile
        return if guard_file?
        init_guard!
      end

      def guardfile_append_konacha_config
        validate_driver!

        unless guard_content? ":konacha, :driver => :#{driver}"
          say "configuring Konacha js driver: #{driver}"
          template_into 'Guard_konacha.erb', 'Guardfile'
        end
      end

      protected

      include EmberKonacha::GemHelper

      def guard_file?
        File.exist? guard_file
      end

      def guard_content? content
         guard_file_content =~ /#{Regexp.escape content}/
       end

      def guard_file_content
        @gfc ||= File.open(guard_file).read
      end

      def guard_file
        Rails.root.join('Guardfile')
      end

      def validate_driver!
        unless valid_driver? driver
          say "Not a valid driver: #{driver}. Must be one of: #{valid_drivers}", :red
          exit
        end
      end

      def tpl_guard_koncha
        @tpl ||= ERB.new template_content('Guard_konacha.erb')
      end

      def tpl_execute tpl
        tpl.result(self.get_binding)
      end

      def get_binding
        binding
      end

      def template_into tmp_source, target        
        gsub_file target, /guard :konacha/ do
          driver_statement
        end
      end

      def driver_statement
        if self.respond_to?(driver, true)
          send(driver)
        else
          say "No konacha config method found for: #{driver}, using default", :red
          selenium
        end
      end

      def driver
        options[:driver] || 'selenium'
      end

      def valid_driver? name
        valid_drivers.include? name.to_s
      end

      def valid_drivers
        %w{selenium poltergeist webkit}
      end

      def selenium
        %q{guard :konacha}
      end

      def poltergeist
        %q{require 'capybara/poltergeist'
guard :konacha, :driver => :poltergeist}
      end

      def webkit
        %q{require 'capybara-webkit'
guard :konacha, :driver => :webkit}
      end

      def template_content path
        File.open(template_path path).read
      end

      def template_path path
        File.join(TPL_PATH, path)
      end

      def init_guard!
         say_status :run, "guard init"
        %x[guard init]
      end
    end
  end
end

