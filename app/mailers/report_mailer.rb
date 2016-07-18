class ReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report.daily.subject
  #
  def daily(report)
    @report = report
    mail to: "mgardner@mapc.org, proche@mapc.org, nduffy@mapc.org", from: "peakdemand@mapc.org", subject: "Peak Load Update"
  end
end
