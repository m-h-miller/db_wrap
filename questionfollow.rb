require 'singleton'
require 'sqlite3'
require_relative 'questions'

class QuestionFollow
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL

    result.map { |result| QuestionFollow.new(result) }
    result.first
  end

  attr_accessor :id, :user_id, :question_id

  def initialize(options = {})
    @id, @user_id, @question_id =
      options.values_at('id', 'user_id', 'question_id')
  end
end
