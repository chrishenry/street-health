SOCRATA = {}

SOCRATA[:app_token] = ENV["SOCRATA_APP_TOKEN"]
SOCRATA[:app_secret] = ENV["SOCRATA_APP_SECRET"]
SOCRATA[:domain] = ENV["SOCRATA_APP_DOMAIN"]

Rails.configuration.socrata = SOCRATA
