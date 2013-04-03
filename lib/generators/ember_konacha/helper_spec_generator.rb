require 'generators/ember_konacha/base_helper'

module EmberKonacha
  module Generators
    class HelperSpecGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_model
        template "specs/helper_spec.js.coffee.erb", spec_target
      end

      protected

      include EmberKonacha::BaseHelper

      def folder
        'helpers'
      end      

      def helper_name
        "App.#{class_name}Helper"
      end
    end
  end
end