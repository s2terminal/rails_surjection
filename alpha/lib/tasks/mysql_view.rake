namespace :mysql_view do
  desc "Swapping table alpha to beta"
  task :swap, ['alpha', 'beta'] => :environment do |task, args|
    alpha_table = args['alpha']
    beta_table = args['beta']

    swap_table(alpha_table, beta_table)

    puts "To rollback, run this command."
    puts "$ bin/rails #{task.name}[#{beta_table},#{alpha_table}]"
  end

  task :check, ['alpha', 'beta'] => :environment do |task, args|
    alpha_table = args['alpha']
    beta_table = args['beta']

    columns = check_equal_table(alpha_table, beta_table)
    if columns[:errors].empty?
      puts "There is no difference between #{alpha_table} and #{beta_table}."
    else
      puts "There are some difference between #{alpha_table} and #{beta_table}."
    end
    puts *columns
  end

  def swap_table(alpha, beta)
    tmp = "#{alpha}_tmp"
    ActiveRecord::Base.connection.execute(
      "RENAME TABLE #{alpha} TO #{tmp}, #{beta} TO #{alpha}, #{tmp} TO #{beta};"
    )
  end

  def check_equal_table(alpha, beta)
    alpha_columns = ActiveRecord::Base.connection.columns(alpha)
    beta_columns  = ActiveRecord::Base.connection.columns(beta)
    equals = []
    errors = []

    alpha_columns.each do |alpha_column|
      beta_column_array = beta_columns.select{|beta_column| alpha_column.name == beta_column.name }
      if beta_column_array.length != 1
        errors.push("Column name error: count of #{alpha_column.name} is #{beta_column_array.length}")
        next
      end
      beta_column = beta_column_array.first

      if alpha_column.type != beta_column.type
        errors.push("Column type error: #{alpha}.#{alpha_column.name} is #{alpha_column.type}, but #{beta}.#{beta_column.name} is #{beta_column.type}")
        next
      end

      equals.push({name: alpha_column.name, type: alpha_column.type})
    end

    {equals: equals, errors: errors}
  end
end
