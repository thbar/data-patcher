require File.dirname(__FILE__) + '/spec_helper'

describe DataPatcher do
  
  before(:each) do
    @existing_item_1 = {
                :title => "Mastering Data Warehouse Aggregates",
                :summary => "The first book to provide in-depth coverage of star schema aggregates...",
                :asin => "0471777099" }
    @existing_item_2 = {
                  :title => "The Data Warehouse ETL Toolkit",
                  :summary => "The single most authoritative guide on the most difficult phase of building a data warehouse",
                  :asin => "0764567578" }
    @existing_items = [@existing_item_1, @existing_item_2]
    Item.delete_all
    Item.create!(@existing_item_1)
    Item.create!(@existing_item_2)
    @patcher = DataPatcher.new
  end
  
  def patcher
    @patcher
  end
  
  it "provides an addition patch including the key and the attributes" do
    patcher.analyze_records(:asin, @existing_items)
    patcher.analyze_record(:asin, { :asin => "123", :title => "Hello", :summary => "The best of hello world" } )
    patcher.patch.should == {
      :added => [{ :asin => "123", :title => "Hello", :summary => "The best of hello world" }]
    }
  end
  
  it "provides a modification patch including the key and updated attributes" do
    patcher.analyze_records(:asin, @existing_items)
    patcher.analyze_record(:asin, { 
      :asin => "0471777099", # key
      :title => "Mastering Data Warehouse Aggregates (Hard cover)", # changed data
      :summary => "The first book to provide in-depth coverage of star schema aggregates..."}) # unchanged data
    patcher.patch.should == {
      :modified => [{ :asin => "0471777099", :title => "Mastering Data Warehouse Aggregates (Hard cover)"}]
    }
  end
  
end
