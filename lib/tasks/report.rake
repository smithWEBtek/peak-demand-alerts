# require 'certifed-update'

namespace :report do
  desc "TODO"
  task update: :environment do
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
    url = "https://webservices.iso-ne.com/api/v1.1/morningreport/current"
    response = JSON.parse RestClient::Request.execute method: :get, url: url, user: 'mgardner@mapc.org', password: 'Foth7880'
    response["MorningReports"]["MorningReport"]

    report = Report.create!

    # report.forecasts.

  end
end
