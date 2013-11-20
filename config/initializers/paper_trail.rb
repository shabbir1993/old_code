module PaperTrail
  class Version < ActiveRecord::Base
    attr_accessible :columns_changed, :phase_change, :area_change, :split_id

    scope :history, -> { joins('INNER JOIN films ON films.id = versions.item_id').where( films: { deleted: false }).order('versions.created_at DESC') } 
    scope :resizes_and_splits, -> { where("('width' = ANY (columns_changed) OR 'length' = ANY (columns_changed)) AND (phase_change[1] <> 'inspection' OR phase_change[1] is NULL)") }

    def after
      self.next ? self.next.reify : Film.find(item_id)
    end

    def area_diff
      area_change[1].to_f - area_change[0].to_f
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
        csv << %w(Serial Formula Width Length Order User DateTime)
        all.each do |v|
          csv << [v.after.serial, v.reify.formula, v.after.width, v.after.length, v.after.sales_order_code, v.created_at]
        end
      end
    end
  end
end
