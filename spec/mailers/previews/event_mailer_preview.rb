# Preview all emails at http://localhost:3000/rails/mailers/event_mailer_mailer
class EventMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/event_mailer_mailer/invite_notification
  def invite_notification
    EventMailer.invite_notification
  end

end
