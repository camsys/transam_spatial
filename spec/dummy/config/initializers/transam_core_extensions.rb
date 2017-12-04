
# Defines services to use
Rails.application.config.new_user_service = "NewUserService"
Rails.application.config.policy_analyzer = "PolicyAnalyzer"

Rails.application.config.rgeo_factory = RGeo::Geographic.spherical_factory(srid: 4326)
