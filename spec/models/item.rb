class Item < ActiveRecord::Base
  validates_presence_of :title, :summary, :asin
  validates_uniqueness_of :asin
end
