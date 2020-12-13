require 'csv'

Invoice.destroy_all
Merchant.destroy_all
Customer.destroy_all

# before running "rake db:seed", do the following:
# - put the "rails-engine-development.pgdump" file in db/data/
# - put the "items.csv" file in db/data/

# - Import the CSV data into the Items table

cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d rails_engine_development db/data/rails-engine-development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

csv_text = File.read(Rails.root.join('db', 'data', 'items.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  t = Item.new(
    id: row['id'],
    name: row['name'],
    description: row['description'],
    unit_price: (row['unit_price'].to_f / 100),
    merchant_id: row['merchant_id']
  )
  t.save
end
puts "There are now #{Item.count} rows in the items table"


# - Add code to reset the primary key sequences on all 6 tables (merchants, items, customers, invoices, invoice_items, transactions)
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end
