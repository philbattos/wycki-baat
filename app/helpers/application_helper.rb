module ApplicationHelper

  BOOTSTRAP_ALERTS = {
    success: 'alert-success',
    notice: 'alert-info',
    alert: 'alert-warning',
    error: 'alert-danger'
  }

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_ALERTS.fetch(flash_type.to_sym)
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(
        content_tag(:div, message, :class => "alert #{bootstrap_class_for(msg_type)} fade in") do
          concat content_tag(:button, 'x', :class => "close", data: { dismiss: 'alert' })
          concat message
        end
      )
    end
    nil
  end

end
