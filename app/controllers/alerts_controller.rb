class AlertsController < ApplicationController

  def index
  end

  def create
    # ActionCable.server.broadcast 'alerts', message: params[:message][:body]

    # head :ok
  end
end