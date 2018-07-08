class CreateBetaUserView < ActiveRecord::Migration[5.2]
  def source_database
    # TODO: use environment information
    "development_beta"
  end

  def self.up
    execute <<-SQL
      CREATE VIEW beta_users (id, name, email, created_at, updated_at)
        AS SELECT b_users.id, b_users.name, b_emails.adress, b_users.created_at, b_users.updated_at
        FROM #{source_database}.users AS b_users LEFT JOIN #{source_database}.emails AS b_emails
          ON b_users.id = b_emails.user_id
    SQL
  end

  def self.down
    execute <<-SQL
      DROP VIEW beta_users
    SQL
  end

end
