module EmberKonacha
  module BaseHelper    
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