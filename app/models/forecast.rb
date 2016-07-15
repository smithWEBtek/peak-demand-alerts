class Forecast < ActiveRecord::Base

	extend Enumerize 
  before_save :set_risk_category
	belongs_to :report

	validates :peak_load, presence: true

	enumerize :risk, in: [:unlikely, :possible, :likely, :unknown], default: :unknown

  def set_risk_category
    # Always retrieve the latest configuration
    config = Config.order("created_at ASC").last

    min = config.possible_min
    max = config.possible_max

    likely = Range.new(min, max)

    result = case
       when likely.include?(peak_load) then "possible"
       when peak_load < likely.min then "unlikely"
       when peak_load > likely.min then "likely"
    end

    self.risk = result
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |forecast|
        csv << forecast.attributes.values_at(*column_names)
      end
    end
  end
end
