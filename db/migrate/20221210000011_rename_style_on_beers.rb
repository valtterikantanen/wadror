class RenameStyleOnBeers < ActiveRecord::Migration[7.0]
  def change
    change_table :beers do |t|
      t.rename :style, :old_style
    end
  end
end
