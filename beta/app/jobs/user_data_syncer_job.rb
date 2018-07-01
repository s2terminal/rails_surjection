class UserDataSyncerJob < ApplicationJob
  queue_as :default

  def perform(object)
    object.surjective_data_sync
  end
end
