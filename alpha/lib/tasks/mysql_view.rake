namespace :mysql_view do
  desc "Swapping table alpha to beta"

  task :swap, ['alpha', 'beta'] => :environment do |task, args|
    alpha_table = args['alpha']
    beta_table = args['beta']

    swap_table(alpha_table, beta_table)

    puts "To rollback, run this command."
    puts "$ bin/rails #{task.name}[#{beta_table},#{alpha_table}]"
  end

  def swap_table(alpha, beta)
    tmp = "#{alpha}_tmp"
    ActiveRecord::Base.connection.execute(
      "RENAME TABLE #{alpha} TO #{tmp}, #{beta} TO #{alpha}, #{tmp} TO #{beta};"
    )
  end
end
