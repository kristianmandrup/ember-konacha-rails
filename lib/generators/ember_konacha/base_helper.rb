module EmberKonacha
  class BaseHelper < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    class_option :ext, :type => :string, :default => 'coffee', :description => "Script language generated (coffee or javascript)" 

    protected

    def spec_template filename
      template spec_template("specs/#{filename}#{ext}.erb"), spec_target
    end

    def ext
      @ext ||= ext_name
    end

    def ext_name
      options[:ext] == 'coffee' ? 'js.coffee' : 'js'
    end

    def spec_target
      target_file File.join(folder, "#{file_name}_spec.js.coffee")
    end

    def target_file path
      File.join target_dir, path
    end

    def target_dir
      "spec/javascripts/app/"
    end
  end
end