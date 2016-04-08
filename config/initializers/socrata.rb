SOCRATA = {}

SOCRATA[:app_token] = ENV["SOCRATA_APP_TOKEN"]
SOCRATA[:app_secret] = ENV["SOCRATA_APP_SECRET"]
SOCRATA[:domain] = ENV["SOCRATA_APP_DOMAIN"]
SOCRATA[:dataset_id] = ENV["SOCRATA_DATASET_ID"]

# TODO: if any of the above are nil, don't start the application

Rails.configuration.socrata = SOCRATA
