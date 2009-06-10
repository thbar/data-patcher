require 'active_record'
require 'active_support'

class DataPatcher
  attr_reader :model, :key, :patch
  
  # model: activerecord class
  # key: unique key accross all model instances
  def initialize(model, key)
    @model = model
    @key = key
    @patch = {}
  end

  # attributes hash must include key
  def find_model(attributes)
    model.find(:first, :conditions => { key => attributes[key] })
  end
  
  def analyze_record(attributes)
    existing = find_model(attributes)
    if existing
      existing_attributes = existing.attributes.dup.symbolize_keys.except(:id)
      diff = attributes.diff(existing_attributes)
      # always include the key in the mix so that a look-up is possible when applying the patch
      unless diff.empty?
        diff[key] = attributes[key]
        modifications << diff
      end
    else
      additions << attributes
    end
  end
  
  def additions
    patch[:added] ||= []
  end
  
  def modifications
    patch[:modified] ||= []
  end
  
  def apply!
    additions.each { |attributes| model.create!(attributes) }
    modifications.each do |attributes|
      instance = find_model(attributes)
      raise "Failed to find or update #{model} with <#{key}> = <#{key_value}>" if instance.nil? || !instance.update_attributes(attributes)
    end
  end
  
end

