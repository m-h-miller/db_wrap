require 'singleton'
require 'sqlite3'
require_relative 'questions'
require 'byebug'

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

    result.map { |result| QuestionLike.new(result) }.first
  end

  def self.likers_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        user_id
      FROM
        question_likes
      WHERE
        question_likes.question_id = ?
    SQL

    result.map { |result| User.find_by_id(result["user_id"]) }
  end

  def self.num_likes_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(user_id) AS num
      FROM
        question_likes
      GROUP BY
        question_likes.question_id = ?
    SQL

    results.map { |res| res["num"] }.first
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        question_id
      FROM
        question_likes
      WHERE
        user_id = ?
    SQL

    results.map { |res| Question.find_by_id(res["question_id"])}
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes
        ON questions.id = question_likes.question_id
      GROUP BY
        question_likes.question_id
      ORDER BY
        COUNT(question_likes.user_id)
      LIMIT ?
    SQL

    results.map { |res| Question.new(res) }
  end

  attr_accessor :id, :question_id, :user_id

  def initialize(options = {})
    @id, @user_id, @question_id =
      options.values_at('id', 'user_id', 'question_id')
  end
end
