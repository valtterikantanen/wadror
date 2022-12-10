class AddStyleIdToBeersFromStyles < ActiveRecord::Migration[7.0]
  def change
    execute "UPDATE Beers SET style_id = 1 WHERE old_style = 'Lager'"
    execute "UPDATE Beers SET style_id = 2 WHERE old_style = 'Pale Ale'"
    execute "UPDATE Beers SET style_id = 3 WHERE old_style = 'Porter'"
    execute "UPDATE Beers SET style_id = 4 WHERE old_style = 'Weizen'"
    execute "UPDATE Beers SET style_id = 5 WHERE old_style = 'IPA'"
    execute "UPDATE Beers SET style_id = 6 WHERE old_style = 'lowalcohol'"
  end
end
