class Report < ActiveRecord::Base
	has_many :forecasts

  after_save :scrape

  scope :today, -> { where(:created_at => (Time.now.beginning_of_day..Time.now.end_of_day)) }
  scope :latest, -> { order("created_at").last }

  def actual_forecast
    forecasts.where(projection: false).first
  end
  
  def scrape
    # https://www.wunderground.com/weather/api/d/docs?d=data/conditions
    # https://www.wunderground.com/weather/api/d/docs?d=data/conditions
    forecast = self.forecasts.create( projection: false, 
                                      high_temp: morning_report["CityForecastDetail"].find {|i| i["CityName"] == "Boston" }["HighTemperature"],
                                      peak_hour: DateTime.parse(peak_load["BeginDate"]),
                                      peak_load: peak_load["LoadMw"].to_i,
                                      actual_peak_hour: Time.parse(morning_report["PeakLoadYesterdayHour"]).hour,
                                      actual_peak_load: morning_report["PeakLoadYesterdayMw"],
                                      date: Date.current)

    seven_day_forecast.first["MarketDay"].each do |day|
      high_temp = day["Weather"]["CityWeather"].select{ |hash| hash["CityName"] == "Boston" }[0]["HighTempF"]
      self.forecasts.create(projection: true,
        high_temp: high_temp,
        peak_load: day["PeakLoadMw"],
        date: Date.parse(day["MarketDate"])
        )
    end

  end

  def peak_load 
    current_hourly_load.sort_by { |hour| hour["LoadMw"] }.last
  end

  def morning_report
    url = "https://webservices.iso-ne.com/api/v1.1/morningreport/current.json"
    request_json(url)["MorningReports"]["MorningReport"].first
  end

  def current_hourly_load
    date = Time.now.strftime("%Y%m%d")
    url = "https://webservices.iso-ne.com/api/v1.1/hourlyloadforecast/day/#{date}.json"
    request_json(url)["HourlyLoadForecasts"]["HourlyLoadForecast"]
  end

  def seven_day_forecast
    url = "https://webservices.iso-ne.com/api/v1.1/sevendayforecast/current.json"
    request_json(url)["SevenDayForecasts"]["SevenDayForecast"]
  end

  def request_json(url)
    request = RestClient::Request.execute method: :get, url: url, user: ENV.fetch('ISO_USER'), password: ENV.fetch("ISO_PASS")
    JSON.parse request
  end
end
