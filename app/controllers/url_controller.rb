class UrlController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :html, :json

  def index
  end

  def create
    full_url = params[:full_url]
    if full_url
      url = Url.new
      alphabet = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
      short_url = (0...4).map { alphabet[rand(alphabet.length)] }.join
      begin
        full_url = full_url.match( /\A(https?:\/\/[^\n]+)\z/i ).captures[0]
      rescue
        full_url = nil
      end
      if !full_url or full_url.nil?
        flash[:error] = "Use URL which starts from http(s)://"
        redirect_to root_url
      end
      url.full_url = full_url
      url.short_url = short_url
      if url.save!
        @msg = "#{root_url}#{short_url}"
        @msg_json = { url: @msg, status: 'ok', message: 'url has been saved' }
        respond_with @msg_json, location: root_url
      else
        flash[:error] = 'Unable to save message, please try again without later'
        @msg_json = { url: '', status: 'failed', message: 'unable to save' }
        respond_with @msg_json, location: root_url
        redirect_to root_url
      end
    end
  end

  def show
    short_url = params[:id] if params[:id] =~ /\A[a-zA-Z0-9]{4}\z/
      record = Url.find_by!( short_url: short_url )
      if record
        redirect_to record.full_url
      else
        flash[:error] = "Message wasn't found"
        redirect_to root_url
      end
      rescue ActiveRecord::RecordNotFound
        flash[:error] = "Message wasn't found"
        redirect_to root_url
  end
end

