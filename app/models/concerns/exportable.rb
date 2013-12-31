module Exportable
  extend ActiveSupport::Concern

  module ClassMethods
    
    def to_csv(data = data_for_export, options = {})
      CSV.generate(options) do |csv|
        data.each do |row|
          csv << row
        end
      end
    end
  end
end
