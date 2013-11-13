module PaperTrail
  class Version < ActiveRecord::Base
    attr_accessible :columns_changed, :phase_change, :area

    scope :history, -> { joins('INNER JOIN films ON films.id = versions.item_id')
      .where( films: { deleted: false })
      .order('versions.created_at DESC') }

  end
end
