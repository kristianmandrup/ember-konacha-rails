require 'generators/ember_konacha/base_helper'

module EmberKonacha
  module Generators
    class ModelSpecGenerator < ::EmberKonacha::BaseHelper
      def create_file
        template 'model_spec'
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