class AlertsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'alerts'
  end
end