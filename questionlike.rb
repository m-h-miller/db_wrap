require 'singleton'
require 'sqlite3'
require_relative 'questions'

class QuestionLike
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL

    result.map { |result| QuestionLike.new(result) }
    result.first
  end

  attr_accessor :id, :question_id, :user_id

  def initialize(options = {})
    @id, @user_id, @question_id =
      options.values_at('id', 'user_id', 'question_id')
  end
end
