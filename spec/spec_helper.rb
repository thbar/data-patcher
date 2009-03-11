require 'rubygems'
require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'data_patcher'

Spec::Runner.configure do |config|
  
end

require 'active_record'
require 'active_record/connection_adapters/mysql_adapter'

require 'yaml'

# database configuration and fixtures setup

ActiveRecord::Base.establish_connection(YAML.load(IO.read(File.dirname(__FILE__) + "/database.yml")))

# Load Models
Dir[File.dirname(__FILE__) + "/models/*.rb"].sort.each do |file|
  require file.gsub(/\.rb$/, '')
end

# Set up database tables and records
Dir[File.dirname(__FILE__) + "/db/migrations/*.rb"].each do |file|
  require file.gsub(/\.rb$/, '')
end

