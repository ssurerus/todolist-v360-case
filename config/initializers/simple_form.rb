SimpleForm.setup do |config|
  # Wrappers configration
  config.wrappers :default, class: "flex flex-col justify-center w-full gap-2" do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: "font-semibold", error_class: "text-red-500"
    b.use :input, class: "flex w-full font-medium p-2.5 text-black border border-cyan-gray rounded bg-cyan-gray/30", error_class: "border-red-500 placeholder-red-400"
  end

  # Default configuration
  config.generate_additional_classes_for = []
  config.default_wrapper                 = :default
  config.button_class                    = "btn"
  config.label_text                      = lambda { |label, _, _| label }
  config.error_notification_tag          = :div
  config.error_notification_class        = "error_notification"
  config.browser_validations             = false
  config.boolean_style                   = :nested
end
