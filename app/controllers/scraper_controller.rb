class ScraperController < ApplicationController
  def scrape
    url = params[:url]
    fields = params[:fields]

    if url.nil? || fields.nil?
      render json: { error: 'URL and fields are required' }, status: :unprocessable_entity
      return
    end

    begin
      response = ScraperService.new.scrape(url, fields)
      render json: response
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
