require "rails/generators"

module TurboToastify
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_initializer
        copy_file "turbo_toastify.rb", "config/initializers/turbo_toastify.rb"
      end
    end
  end
end
