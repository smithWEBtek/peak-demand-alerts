class Report < ActiveRecord::Base
	has_many :forecasts

  after_save :scrape

  def scrape
    # https://webservices.iso-ne.com/api/v1.1/morningreport/current
    # https://webservices.iso-ne.com/api/v1.1/hourlyloadforecast/day/20160622.json
    # https://webservices.iso-ne.com/api/v1.1/hourlyloadforecast/day/20160622.json
    # https://webservices.iso-ne.com/api/v1.1/sevendayforecast/current.json
    # https://webservices.iso-ne.com/api/v1.1/sevendayforecast/current.json
    # https://webservices.iso-ne.com/api/v1.1/sevendayforecast/current.json
    # https://webservices.iso-ne.com/api/v1.1/morningreport/current.json
    # https://webservices.iso-ne.com/api/v1.1/morningreport/current.json
    # https://www.wunderground.com/weather/api/d/docs?d=data/conditions
    # https://www.wunderground.com/weather/api/d/docs?d=data/conditions

    ### High Temperature
    # url = "https://webservices.iso-ne.com/api/v1.1/morningreport/current.json"
    # response = JSON.parse(RestClient::Request.execute( method: :get, url: url, user: 'mgardner@mapc.org', password: 'Foth7880'))
    # response["MorningReports"]["MorningReport"].first["CityForecastDetail"].find {|i| i["CityName"] == "Boston" }
    forecast = self.forecasts.create( projection: false, 
                                      high_temp: morning_report["CityForecastDetail"].find {|i| i["CityName"] == "Boston" }["HighTemperature"],
                                      peak_hour: Time.parse(peak_load["BeginDate"]).hour,
                                      peak_load: peak_load["LoadMw"],
                                      actual_peak_hour: Time.parse(morning_report["PeakLoadYesterdayHour"]).hour,
                                      actual_peak_load: morning_report["PeakLoadYesterdayMw"],
                                      date: Date.current)

    seven_day_forecast.first["MarketDay"].each do |day|
      self.forecasts.create(projection: true,
        high_temp: day["HighTemp"],
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
