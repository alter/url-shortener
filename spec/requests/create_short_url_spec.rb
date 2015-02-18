require 'rails_helper'

RSpec.describe "create short url", :type => :request do
  it "creates short_url for full_url" do
    get "/"
    expect(response).to render_template(:index)
    post "/", :full_url => "www.asd.ru"
    expect(response).to render_template(:create)
    expect(response.body).to include "http://"
  end
end
