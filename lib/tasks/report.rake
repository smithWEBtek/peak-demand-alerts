# require 'certifed-update'

namespace :report do
  desc "TODO"
  task update: :environment do

    report = Report.create!
    report.scrape
    # Maybe invoke the e-mail rake task
    # user a mailer and mailer template
    # report.forecasts.

  end
end
