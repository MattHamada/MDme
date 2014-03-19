module MailerMacros
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def all_emails_to
    to = []
    ActionMailer::Base.deliveries.each { |d| to << d.to }
    to
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end
end