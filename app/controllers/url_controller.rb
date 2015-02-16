class UrlController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :html, :json

  SHORT_URL_LENGTH = 4

  def is_short_url_created?( short_url )
    Url.find_by( short_url: short_url ) ? true : false
  end

  def generate_short_url()
    alphabet = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
    short_url = (0...SHORT_URL_LENGTH).map { alphabet[rand(alphabet.length)] }.join
    if is_short_url_created? short_url
      generate_short_url()
    else
      return short_url
    end
  end

  def search_full_url_in_db( full_url )
    record = Url.find_by( full_url: full_url )
    if record
      return record.short_url
    else
      return nil
    end
  end

  def is_valid_param?( param )
    result = param.chars.map { |c|
      if( c =~ /[\w\:\/\.]/ ).nil?
        break
      else
        true
      end
    }
    result.nil? ? false : true
  end


  def is_full_url_valid?( full_url )
    if is_valid_param? full_url
      response = %x[ curl -k -s -I #{full_url} | head -1 | awk '{print $2}' | tr -d '\n' ].to_i
      response == 0 ? false : true
    else
      false
    end
  end

  def index
  end

  def create
    full_url = params[:full_url]
    if full_url and is_full_url_valid? full_url
      short_url = search_full_url_in_db( full_url )
      url = Url.new
      if short_url.nil?
        short_url = generate_short_url()
        url.full_url = full_url
        url.short_url = short_url
        if url.save!
          @msg = "#{root_url}#{short_url}"
          @msg_json = { url: @msg, status: 201, message: 'url has been saved' }
          respond_with @msg_json, location: root_url
        else
          flash[:error] = 'Unable to save message, please try again without later'
          @msg_json = { url: nil, status: 500, message: 'unable to save' }
          respond_with @msg_json, location: root_url
          redirect_to root_url
        end
      else
        @msg = "#{root_url}#{short_url}"
        @msg_json = { url: @msg, status: 200, message: 'url has been found' }
        respond_with @msg_json, location: root_url
      end
    else
      flash[:error] = 'Please fill url field correctly'
      redirect_to root_url
    end
  end

  def show
    short_url = params[:id] if params[:id] =~ /\A[a-zA-Z0-9]{#{SHORT_URL_LENGTH}}\z/
    if short_url
      record = Url.find_by( short_url: short_url )
      if !record.nil?
        if record.full_url =~ /.*(:\/\/).*/
          Url.update_counters record.id, :redirected => 1
          @msg_json = { url: record.full_url, status: 200, message: 'url with protocol' }
          respond_with @msg_json, location: root_url do |format|
            format.html { redirect_to record.full_url }
          end
        else
          @msg_json = { url: record.full_url, status: 200, message: 'url without protocol' }
          respond_with @msg_json, location: root_url do |format|
            format.html { redirect_to "http://#{record.full_url}" }
          end
        end
      else
        flash[:error] = "Message wasn't found"
        redirect_to root_url
      end
    else
      flash[:error] = "Message wasn't found"
      redirect_to root_url
    end
  end
end

