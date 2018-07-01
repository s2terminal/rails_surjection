class Email < ApplicationRecord
  belongs_to :user
  after_save -> { UserDataSyncerJob.perform_later(self) }

  def surjective_data_sync
    self.user.surjective_data_sync
  end

end
