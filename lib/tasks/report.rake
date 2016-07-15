# require 'certifed-update'

namespace :report do
  desc "TODO"
  task update: :environment do
    report = Report.new
    report.save!
    # Maybe invoke the e-mail rake task
    # user a mailer and mailer template
    # report.forecasts.

    # API_KEY = ENV['MAILGUN_API_KEY']
    # MAILGUN_DOMAIN = ENV['MAILGUN_DOMAIN']

    # API_URL = "https://api:#{API_KEY}@api.mailgun.net/v3/#{MAILGUN_DOMAIN}"

    ReportMailer.daily(report).deliver
  end
end
