class FilmMovement < ActiveRecord::Base
  attr_accessible :from, :to, :area, :created_at
  belongs_to :film

  scope :fg, where(to: "FG")

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = FilmMovement.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
    ActiveRecord::Base.connection.execute("SELECT setval('film_movements_id_seq', (SELECT MAX(id) FROM film_movements));")
  end
end

