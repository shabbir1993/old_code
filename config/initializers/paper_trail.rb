module PaperTrail
  class Version < ActiveRecord::Base
    attr_accessible :columns_changed, :phase_change, :area_change, :split_id

    scope :history, -> { joins('INNER JOIN films ON films.id = versions.item_id').where( films: { deleted: false }).order('versions.created_at DESC') } 

    def after
      self.next ? self.next.reify : Film.find(item_id)
    end

    def datetime_display
      if created_at.year == Time.zone.today.year
        created_at.strftime("%e %b %R")
      else
        created_at.strftime("%F %R")
      end
    end

    def self.fg_film_movements_to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << %w(Serial Width Length Order User DateTime)
        all.each do |v|
          csv << [v.after.serial, v.after.width, v.after.length, v.after.sales_order_code, v.created_at]
        end
      end
    end
  end
end
