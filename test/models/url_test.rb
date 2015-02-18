require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  test 'should save urls correctly if filled short_url and full_url' do
    url = Url.new
    url.short_url = 's4KK'
    url.full_url = 'https://mail.ru'
    assert url.save
  end

  test 'should not save urls without filled short_url' do
    url = Url.new
    url.full_url = 'http://www.yandex.ru'
    assert_not url.save, 'Saved url without short_url'
  end

  test 'should not save urls without filled full_url' do
    url = Url.new
    url.short_url = '6Gbz'
    assert_not url.save, 'Saved url without short_url'
  end

  test 'should not save urls without filled full_url and short_url' do
    url = Url.new
    assert_not url.save, 'Saved url without full_url and short_url'
  end
end

