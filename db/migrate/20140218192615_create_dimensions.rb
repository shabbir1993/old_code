class CreateDimensions < ActiveRecord::Migration
  SECOND_WIDTH_SQL = "substring(films.note from '([0-9]+([.][0-9]+)?)[ ]*[xX][ ]*([0-9]+([.][0-9]+)?)')::decimal"
  SECOND_LENGTH_SQL = "substring(films.note from '(?:[0-9]+(?:[.][0-9]+)?)[ ]*[xX][ ]*([0-9]+([.][0-9]+)?)')::decimal"
  def up
    create_table :dimensions do |t|
      t.decimal :width, null: false, default: 0
      t.decimal :length, null: false, default: 0
      t.integer :film_id, null: false
    end

    Film.unscoped.select("films.*, #{SECOND_WIDTH_SQL} as second_width, #{SECOND_LENGTH_SQL} as second_length").each do |f|
      if f.read_attribute('width') && f.read_attribute('length')
        dimension = f.dimensions.build(width: f.width, length: f.length)
        dimension.save!
      end
      if f.second_width && f.second_length
        second_dimension = f.dimensions.build(width: f.second_width, length: f.second_length)
        second_dimension.save!
      end
    end

    Film.unscoped.each do |f|
      if f.dimensions.empty?
        dimension = f.dimensions.build
        dimension.save!
      end
    end
  end

  def down 
    drop_table :dimensions
  end
end
