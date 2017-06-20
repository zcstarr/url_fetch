class Page < ApplicationRecord
  validates :url, presence: true
  validates :parsed, presence: true
  validates :chksum, presence: true
end
