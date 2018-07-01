class User < ApplicationRecord
  has_many :emails, dependent: :destroy
end
