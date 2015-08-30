class PortalsController < ApplicationController

  def fetch_query
    # portal    = Portal.new
    # response  = portal.fetch(request.query_string)

    # render json: response
    render json: 'inaccessible'
  end

end