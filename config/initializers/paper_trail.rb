module PaperTrail
  class Version < ActiveRecord::Base
    attr_accessible :columns_changed, :phase_change

    default_scope { order('created_at DESC') }
  end
end
