module EmberKonacha
  module GemHelper   
    def bundle_gems!
      bundle_command 'install'
    end

    # File railties/lib/rails/generators/app_base.rb, line 241
    def bundle_command(command)
      say_status :run, "bundle #{command}"

      # We are going to shell out rather than invoking Bundler::CLI.new(command)
      # because `rails new` loads the Thor gem and on the other hand bundler uses
      # its own vendored Thor, which could be a different version. Running both
      # things in the same process is a recipe for a night with paracetamol.
      #
      # We use backticks and #print here instead of vanilla #system because it
      # is easier to silence stdout in the existing test suite this way. The
      # end-user gets the bundler commands called anyway, so no big deal.
      #
      # Thanks to James Tucker for the Gem tricks involved in this call.
      print %x[#{Gem.ruby} -rubygems "#{ruby_gems}" #{command}]
    end

    def ruby_gems
      Gem.bin_path('bundler', 'bundle')
    end

    def has_any_gem? *names
      names.flatten.any? {|name| has_gem? name }
    end

    def has_all_gems? *names
      names.flatten.all? {|name| has_gem? name }
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
  end
end