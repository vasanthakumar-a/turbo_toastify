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
      html = []

      # On full HTML page loads, render the infrastructure
      unless request.format.turbo_stream?
        css_content = TurboToastify::ApplicationHelper.toastify_css
        js_content = TurboToastify::ApplicationHelper.toastify_js

        html << "<style>#{css_content}</style>"
        html << "<div id=\"toast-container-root\" data-turbo-permanent></div>"
        html << "<div id=\"flash-outlet\" data-turbo-cache=\"false\"></div>"
        html << "<script type=\"module\">"
        html << js_content
        html << "</script>"
      end

      # For both HTML and Turbo Streams, execute the toasts if present
      if (scripts = turbo_toastify_script_tag).present?
        html << scripts
      end

      html.join("\n").html_safe
    end

    def turbo_toastify_script_tag
      config = Rails.application.config.try(:turbo_toastify) || {}
      default_position = config[:position] || "top-right"
      default_auto_close = config[:auto_close] || 5000
      default_theme = config[:theme] || "light"
      default_transition = config[:transition] || "slide"
      default_close_button = config.key?(:close_button) ? config[:close_button] : true
      default_pause_on_hover = config.key?(:pause_on_hover) ? config[:pause_on_hover] : true
      default_draggable = config.key?(:draggable) ? config[:draggable] : true

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
        close_button = flash[:toast_close_button].nil? ? default_close_button : flash[:toast_close_button]
        pause_on_hover = flash[:toast_pause_on_hover].nil? ? default_pause_on_hover : flash[:toast_pause_on_hover]
        draggable = flash[:toast_draggable].nil? ? default_draggable : flash[:toast_draggable]

        safe_message = j(message.to_s)

        script_lines << "window.TurboToastify && window.TurboToastify.show('#{safe_message}', { type: '#{j(type.to_s)}', position: '#{j(position.to_s)}', autoClose: #{auto_close.to_i}, theme: '#{j(theme.to_s)}', transition: '#{j(transition.to_s)}', closeButton: #{!!close_button}, pauseOnHover: #{!!pause_on_hover}, draggable: #{!!draggable} });"
      end

      # Discard so it doesn't show up again
      flash.keys.reject { |type| type.to_s.start_with?("toast_") }.each do |type|
        flash.discard(type)
      end

      return nil if script_lines.empty?

      html = []
      html << "<script type=\"module\">"
      html << "  " + script_lines.join("\n  ")
      html << "</script>"

      html.join("\n").html_safe
    end
  end
end
