ActiveRecord::Base.connection.create_table :items, :force => true do |t|
  t.column :title,   :string, :null => false
  t.column :summary, :text, :null => false
  # use asin as a functional key
  t.column :asin,    :string, :null => false
  # TODO - add timestamps here ?
end
