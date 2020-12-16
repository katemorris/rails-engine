class AddTimestampsToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_timestamps(:transactions, null: false)
  end
end
