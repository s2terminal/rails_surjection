class User < ApplicationRecord
  has_many :emails, dependent: :destroy
  after_save -> { UserDataSyncerJob.perform_later(self) }

  def surjective_data_sync
    begin
      email = representative_email

      ActiveRecord::Base.establish_connection("#{Rails.env}_alpha".to_sym)
      # FIXME: You must sanitize params.
      alpha_data = ActiveRecord::Base.connection.select_one(
        "SELECT * FROM Users
          WHERE id = #{self.id}
        "
      )
      if alpha_data.present?
        ActiveRecord::Base.connection.execute(
          "UPDATE Users
            SET name = '#{self.name}', email = '#{email}'
            WHERE id = #{self.id}
          "
        )
      else
        ActiveRecord::Base.connection.execute(
          "INSERT INTO Users
            (id, name, email, created_at, updated_at)
            VALUES ('#{self.id}', #{self.name}, '#{email}', '#{self.created_at}', '#{self.updated_at}')
          "
        )
      end
    rescue => ex
      raise
    ensure
      ActiveRecord::Base.establish_connection(Rails.env.to_sym)
    end
  end

  def representative_email
    self.emails.pluck(:adress).reject{|i|i.blank?}.first.to_s
  end
end
