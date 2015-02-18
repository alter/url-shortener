require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  test 'should save urls correctly if filled short_url and full_url' do
    url = Url.new
    url.short_url = urls(:mail).short_url
    url.full_url = urls(:mail).full_url
    assert url.save
  end

  test 'should not save urls without filled short_url' do
    url = Url.new
    url.full_url = urls(:ya).full_url
    assert_not url.save, 'Saved url without short_url'
  end

  test 'should not save urls without filled full_url' do
    url = Url.new
    url.short_url = urls(:ya).short_url
    assert_not url.save, 'Saved url without short_url'
  end

  test 'should not save urls without filled full_url and short_url' do
    url = Url.new
    assert_not url.save, 'Saved url without full_url and short_url'
  end
end

