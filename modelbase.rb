require_relative 'questions'

class ModelBase

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self::TABLE}
      WHERE
        id = ?
    SQL

    result.map { |result| self.new(result) }.first
  end

  def self.all
    result = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self::TABLE}
    SQL

    result.map { |result| self.new(result) }
  end

  def self.where(options = {})
    col_names = []
    params = []
    options.each do |key, val|
      params << val
      col_names << key.to_s
    end

    result = QuestionsDatabase.instance.execute(<<-SQL, *params)
      SELECT
        *
      FROM
        #{self::TABLE}
      WHERE
        #{col_names.map { |name| name + ' = ?' }.join(" AND ")}
    SQL

    result.map { |result| self.new(result) }
  end

  def save
    args = self.instance_variables.map { |var| var.to_s[1..-1] }
    params = args.map { |var| self.send(var.to_sym) }
    pars = params.drop(1)


    if self.id.nil?
      into_str = '(' + args.drop(1).join(", ") +')'
      vals_str = '(' +('?' * (pars.count)).split('').join(', ') + ')'
      QuestionsDatabase.instance.execute(<<-SQL, *pars)
        INSERT INTO #{self.class::TABLE}
          #{into_str}
        VALUES
          #{vals_str}
      SQL
      self.id = QuestionsDatabase.instance.last_insert_row_id

    else
      pars.concat([params.first])
      QuestionsDatabase.instance.execute(<<-SQL, *pars)
        UPDATE #{self.class::TABLE}
        SET
          #{args.drop(1).map { |name| name + ' = ?' }.join(", ")}
        WHERE
          #{args.first} = ?
      SQL
    end

    self
  end

end
