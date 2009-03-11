require 'activesupport'

class DataPatcher
  
  def analyze_record(key, attributes)
    existing = Item.find_by_asin(attributes[key])
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
  
  # test commodity - remove ?
  def analyze_records(key, records)
    records.each { |record| analyze_record(key, record) }
  end
  
  def patch
    @patch ||= {}
  end
  
end

