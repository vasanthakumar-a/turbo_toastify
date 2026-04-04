require "rails/generators"

module TurboToastify
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_assets_and_templates
        copy_file "app/javascript/toastify/index.js", "app/javascript/toastify/index.js"
        copy_file "app/javascript/controllers/toast_controller.js", "app/javascript/controllers/toast_controller.js"
        copy_file "app/assets/stylesheets/toastify.css", "app/assets/stylesheets/toastify.css"
        copy_file "app/views/shared/_flash.html.erb", "app/views/shared/_flash.html.erb"
        copy_file "config/initializers/turbo_toastify.rb", "config/initializers/turbo_toastify.rb"
      end

      def add_importmap_pin
        importmap = "config/importmap.rb"
        return unless File.exist?(importmap)

        pin_line = 'pin "toastify/index", to: "toastify/index.js"'
        return if File.read(importmap).include?(pin_line)

        append_to_file importmap, "\n#{pin_line}\n"
      end

      def update_application_layout
        layout_path = "app/views/layouts/application.html.erb"
        return unless File.exist?(layout_path)

        layout = File.read(layout_path)

        stylesheet_line = '<%= stylesheet_link_tag "toastify", "data-turbo-track": "reload" %>'
        unless layout.include?(stylesheet_line)
          inject_into_file layout_path, "    #{stylesheet_line}\n", before: "</head>"
        end

        outlet_markup = "    <div id=\"flash-outlet\"></div>\n    <%= render \"shared/flash\" %>\n"
        unless layout.include?("<div id=\"flash-outlet\"></div>")
          inject_into_file layout_path, outlet_markup, before: "<%= yield %>"
        end
      end
    end
  end
end
