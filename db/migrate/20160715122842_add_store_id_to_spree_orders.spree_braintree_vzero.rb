# This migration comes from spree_braintree_vzero (originally 20160714120940)
class AddStoreIdToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :store_id, :integer
    add_index :spree_orders, :store_id
  end
end
