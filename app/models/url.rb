class Url < ActiveRecord::Base
  validates :short_url, presence: true
  validates :full_url, presence: true
end
