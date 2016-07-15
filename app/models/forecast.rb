class Forecast < ActiveRecord::Base

	extend Enumerize 

  include Forecast::RiskCategory

	belongs_to :report

	validates :peak_load, presence: true

	enumerize :risk, in: [:unlikely, :possible, :likely, :unknown], default: :unknown

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |forecast|
        csv << forecast.attributes.values_at(*column_names)
      end
    end
  end
end
