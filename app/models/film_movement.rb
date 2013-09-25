class FilmMovement < ActiveRecord::Base
  attr_accessible :from, :to, :area, :created_at

  belongs_to :film
  belongs_to :user

  default_scope order('created_at DESC')
  scope :fg, where(to: "fg")
  scope :scrap, where(to: "scrap")
  scope :checkout, where(to: ["wip", "fg"])
  scope :reserved, joins(:film).where("films.reserved_for <> ''")

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record = FilmMovement.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
    ActiveRecord::Base.connection.execute("SELECT setval('film_movements_id_seq', (SELECT MAX(id) FROM film_movements));")
  end
end

