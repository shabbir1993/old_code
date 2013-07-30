class FilmMovement < ActiveRecord::Base
  attr_accessible :from, :to, :area, :created_at

  belongs_to :film
  belongs_to :user

  default_scope order('created_at DESC')
  scope :fg, where(to: "fg")

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = FilmMovement.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
    ActiveRecord::Base.connection.execute("SELECT setval('film_movements_id_seq', (SELECT MAX(id) FROM film_movements));")
  end
end

