module TurboToastify
  class Engine < ::Rails::Engine
    isolate_namespace TurboToastify

    initializer "turbo_toastify.helper" do
      ActiveSupport.on_load(:action_view) do
        include TurboToastify::ApplicationHelper
      end
    end

    initializer "turbo_toastify.controller" do
      ActiveSupport.on_load(:action_controller) do
        include TurboToastify::Controller
      end
    end
  end
end
