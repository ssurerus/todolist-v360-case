Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.base_uri    :self
    policy.form_action :self
    policy.frame_ancestors :none
    policy.object_src  :none
    policy.img_src     :self, :data
    policy.script_src  :self
    policy.style_src   :self, "https://fonts.googleapis.com"
    policy.font_src    :self, "https://fonts.gstatic.com"
    policy.connect_src :self
  end

  config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w[script-src style-src]

  config.content_security_policy_nonce_auto = true
end
