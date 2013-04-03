require 'generators/ember_konacha/base_helper'

module EmberKonacha
  module Generators
    class ModelSpecGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_model
        template "specs/model_spec.js.coffee.erb", spec_target
      end

      protected

      include EmberKonacha::BaseHelper

      def folder
        'models'
      end      

      def model_name
        "App.#{class_name}"
      end
    end
  end
end