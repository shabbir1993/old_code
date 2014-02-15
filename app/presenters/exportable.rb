module Exportable

  def to_csv(options = {})
    data = data_for_export
    CSV.generate(options) do |csv|
      data.each do |row|
        csv << row
      end
    end
  end
end
