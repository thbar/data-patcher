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
    
  def analyze_record(attributes)
    existing = model.find(:first, :conditions => { key => attributes[key] })
    if existing
      existing_attributes = existing.attributes.dup.symbolize_keys.except(:id)
      diff = attributes.diff(existing_attributes)
      # always include the key in the mix so that a look-up is possible when applying the patch
      unless diff.empty?
        patch[:modified] ||= []
        diff[key] = attributes[key]
        patch[:modified] << diff
      end
    else
      patch[:added] ||= []
      patch[:added] << attributes
    end
  end
  
end

