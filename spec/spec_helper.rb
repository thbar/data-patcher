require 'rubygems'
require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/../lib")

require 'data_patcher'

Spec::Runner.configure do |config|
  
end

require 'active_record'
require 'active_record/connection_adapters/mysql_adapter'

require 'yaml'

# database configuration and fixtures setup

ActiveRecord::Base.establish_connection(YAML.load(IO.read(File.dirname(__FILE__) + "/../database.yml")))

# Load Models
Dir[File.dirname(__FILE__) + "/models/*.rb"].sort.each do |file|
  require file.gsub(/\.rb$/, '')
end

# Set up database tables and records
Dir[File.dirname(__FILE__) + "/db/migrations/*.rb"].each do |file|
  require file.gsub(/\.rb$/, '')
end

def load_fixture
  @existing_item_1 = {
              :title => "Mastering Data Warehouse Aggregates",
              :summary => "The first book to provide in-depth coverage of star schema aggregates...",
              :asin => "0471777099" }
  @existing_item_2 = {
                :title => "The Data Warehouse ETL Toolkit",
                :summary => "The single most authoritative guide on the most difficult phase of building a data warehouse",
                :asin => "0764567578" }
  Item.delete_all
  Item.create!(@existing_item_1)
  Item.create!(@existing_item_2)
end