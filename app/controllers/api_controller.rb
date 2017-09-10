class ApiController < ApplicationController

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def save
    tag = Tag.find_or_initialize_by uid: params[:tag]
    if tag.new_record?
      tag.name = params[:tag]
      tag.save
    end
    tag.update_attributes status: params[:status], interval: params[:interval]
    if params[:data]
      data = params[:data]
      reading = Reading.create tag: tag, data: data, offset: params[:offset], time: params[:datetime], log_interval: params[:log_interval]
      self.response.headers["Content-Type"] ||= 'text/json'
      self.response.headers["Last-Modified"] = Time.now.ctime.to_s
      self.response_body = Enumerator.new do |yielder|
        reading.interprete yielder
      end
    else
      render json: true
    end
  end

  def save_log
    tag = Tag.find_or_initialize_by uid: params[:tag]
    if tag.new_record?
      tag.name = params[:tag]
      tag.save
    end
    p tag.uid
    tag.update_attributes status: params[:status], interval: params[:interval]
    log = Log.find_or_create_by tag: tag, temp: params[:temp], humidity: params[:humidity], datetime: params[:time].to_i/15000*15000 if params[:humidity].to_i > 0
    render json: true
  end
end
