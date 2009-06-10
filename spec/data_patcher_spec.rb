require File.dirname(__FILE__) + '/spec_helper'

describe DataPatcher do
  
  before(:each) do
    load_fixture
    
    @patcher = DataPatcher.new(Item, :asin)
    # pre-load the patcher with all the existing data, so that we can simulate an addition or modification
    @patcher.analyze_record(@existing_item_1)
    @patcher.analyze_record(@existing_item_2)
  end
  
  it "provides an addition patch including the key and the attributes, and knows how to apply it" do
    @patcher.analyze_record({ :asin => "123", :title => "Hello", :summary => "The best of hello world" } )

    @patcher.patch.should == {
      :added => [{ :asin => "123", :title => "Hello", :summary => "The best of hello world" }]
    }
    
    lambda {
      @patcher.apply!
      item = Item.find(:last)
      item.asin.should == "123"
      item.title.should == "Hello"
      item.summary.should == "The best of hello world"
    }.should change(Item, :count).by(1)
  end
  
  it "provides a modification patch including the key and updated attributes, and knows how to apply it" do
    @patcher.analyze_record( { 
      :asin => "0471777099", # key
      :title => "Mastering Data Warehouse Aggregates (Hard cover)", # changed data
      :summary => "The first book to provide in-depth coverage of star schema aggregates..."}) # unchanged data

    @patcher.patch.should == {
      :modified => [{ :asin => "0471777099", :title => "Mastering Data Warehouse Aggregates (Hard cover)"}]
    }

    item = Item.find_by_asin("0471777099")

    lambda {
      @patcher.apply!
      item.reload
    }.should change(item, :title).
      from("Mastering Data Warehouse Aggregates").
      to("Mastering Data Warehouse Aggregates (Hard cover)")
  end
  
end
