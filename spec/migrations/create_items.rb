ActiveRecord::Base.connection.create_table :items, :force => true do |t|
  t.column :title,   :string, :null => false
  t.column :summary, :text, :null => false
  # use asin as a functional key
  t.column :asin,    :string, :null => false
  # TODO - add timestamps here ?
end

Item.create :title => "Mastering Data Warehouse Aggregates",
            :summary => "tThe first book to provide in-depth coverage of star schema aggregates...",
            :asin => "0471777099"
Item.create :title => "The Data Warehouse ETL Toolkit",
            :summary => "The single most authoritative guide on the most difficult phase of building a data warehouse",
            :asin => "0764567578"
