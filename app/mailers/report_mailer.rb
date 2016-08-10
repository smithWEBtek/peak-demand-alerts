class ReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report.daily.subject
  #
  def daily(report)
    @report = report
    @config = ::Configuration.latest
    # TODO: Add recipients, email setting to admin
    mail to:      ENV.fetch('EMAIL_RECIPIENTS'),
         from:    ENV.fetch('EMAIL_FROM'),
         subject: "Peak Load Update - #{Time.now.strftime('%-d/%-m')}"
  end
end
