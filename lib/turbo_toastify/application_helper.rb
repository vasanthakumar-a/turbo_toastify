module TurboToastify
  module ApplicationHelper
    def self.toastify_css
      @toastify_css ||= begin
        path = File.expand_path("assets/toastify.css", __dir__)
        File.read(path)
      end
    end

    def self.toastify_js
      @toastify_js ||= begin
        path = File.expand_path("assets/toastify.js", __dir__)
        File.read(path)
      end
    end

    def turbo_toastify
      config = Rails.application.config.try(:x).try(:turbo_toastify) || {}
      default_position = config[:position] || "top-right"
      default_auto_close = config[:auto_close] || 5000
      default_theme = config[:theme] || "light"
      default_transition = config[:transition] || "slide"

      type_map = {
        "notice" => "info",
        "success" => "success",
        "alert" => "warning",
        "error" => "error",
        "info" => "info",
        "warning" => "warning",
      }

      script_lines = []
      flash.each do |flash_type, message|
        next if flash_type.to_s.start_with?("toast_")

        type = type_map.fetch(flash_type.to_s, "default")
        position = flash[:toast_position] || default_position
        auto_close = flash[:toast_duration] || default_auto_close
        theme = flash[:toast_theme] || default_theme
        transition = flash[:toast_transition] || default_transition

        safe_message = j(message.to_s)

        script_lines << "TurboToastify.show('#{safe_message}', { type: '#{j(type.to_s)}', position: '#{j(position.to_s)}', autoClose: #{auto_close.to_i}, theme: '#{j(theme.to_s)}', transition: '#{j(transition.to_s)}' });"
      end

      css_content = TurboToastify::ApplicationHelper.toastify_css
      js_content = TurboToastify::ApplicationHelper.toastify_js

      html = []
      html << "<style>#{css_content}</style>"
      html << "<div id=\"toast-container-root\" data-turbo-permanent></div>"
      html << "<div id=\"flash-outlet\" data-turbo-cache=\"false\"></div>"
      html << "<script type=\"module\">"
      html << js_content
      html << "  " + script_lines.join("\n  ") if script_lines.any?
      html << "</script>"

      html.join("\n").html_safe
    end
  end
end
