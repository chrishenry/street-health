require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "vcr_cassettes"
  c.hook_into :webmock
  c.default_cassette_options = {
    :match_requests_on => [:uri]
  }
end

