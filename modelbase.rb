require_relative 'questions'

class ModelBase

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{TABLE}
      WHERE
        id = ?
    SQL

    result.map { |result| User.new(result) }.first
  end
end
