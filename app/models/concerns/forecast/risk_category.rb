class Forecast
  module RiskCategory
    extend ActiveSupport::Concern

    included do 

      before_save :set_risk_category

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
    end
  end
end
