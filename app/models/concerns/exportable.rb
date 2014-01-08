module Exportable
  extend ActiveSupport::Concern

  module ClassMethods
    
    def to_csv(data_method = 'data_for_export', options = {})
      data = self.send(data_method)
      CSV.generate(options) do |csv|
        data.each do |row|
          csv << row
        end
      end
    end
  end
end
