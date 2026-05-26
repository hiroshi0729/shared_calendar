class EventMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def invite_notification(event, guest)
    @event = event
    @guest = guest
    @organizer = event.user
    
    mail(
      to: @guest.email,
      subject: "【イベント招待】#{@event.title} に招待されました"
    )
  end
end
