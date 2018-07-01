class Email < ApplicationRecord
  belongs_to :user
  after_commit -> { self.user.surjective_data_sync }
end
