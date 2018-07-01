class User < ApplicationRecord
  has_many :emails, dependent: :destroy
  after_commit :surjective_data_sync

  def surjective_data_sync
    begin
      ActiveRecord::Base.establish_connection(:development_alpha)
      # FIXME: You must sanitize params.
      alpha_data = ActiveRecord::Base.connection.execute(
        "UPDATE Users
          SET name = '#{self.name}'
          WHERE id = #{self.id}
        "
      )
    rescue => ex
      raise
    ensure
      ActiveRecord::Base.establish_connection(:development)
    end
  end

end
