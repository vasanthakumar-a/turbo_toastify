module TurboToastify
  module Controller
    extend ActiveSupport::Concern

    included do
      after_action :append_turbo_toastify_to_stream
    end

    private

    def append_turbo_toastify_to_stream
      return unless request.format.turbo_stream?

      toast_flashes = flash.reject { |type, _| type.to_s.start_with?("toast_") }
      return unless toast_flashes.any?

      script_content = helpers.turbo_toastify_script_tag
      return if script_content.blank?

      stream_tag = turbo_stream.append("flash-outlet", script_content)

      if response.body.is_a?(String)
        response.body += stream_tag.to_s
      else
        response.body = response.body.to_s + stream_tag.to_s
      end
    end
  end
end
