db_config = YAML.load(ERB.new(File.read('./config/database.yml')).result)
ActiveRecord::Base.establish_connection(db_config[ENV['RACK_ENV']])

require_relative '../lib/status_handlers/base'
require_relative '../lib/status_handlers/success'
require_relative '../lib/status_handlers/failed'
require_relative '../lib/status_handlers/insufficient_funds'
require_relative '../lib/status_handlers/unexpected'

require_all 'app/'
require_all 'lib/'
