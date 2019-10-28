class Shot < ApplicationRecord
  validates :message, presence: true
end
