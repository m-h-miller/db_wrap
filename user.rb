require 'singleton'
require 'sqlite3'
require_relative 'questions'
require_relative 'modelbase'

class User < ModelBase
  TABLE = 'users'
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    result.map { |result| User.new(result) }.first
  end

  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        replies
      WHERE
        fname = ? AND lname = ?
    SQL

    result.map { |result| User.new(result) }.first
  end

  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id, @fname, @lname =
      options.values_at('id', 'fname', 'lname')
  end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_author_id(self.id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    results = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        (CAST(COUNT(question_likes.user_id) AS FLOAT) /
        COUNT(DISTINCT(questions.id))) AS karma
      FROM
        questions
      LEFT OUTER JOIN
        question_likes
        ON questions.id = question_likes.question_id
      WHERE questions.author_id = ?
    SQL

    results.first['karma']
  end

  def save
    if self.id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
        INSERT INTO users
          ('fname', 'lname')
        VALUES
            (?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      params = [self.id, self.fname, self.lname]
      QuestionsDatabase.instance.execute(<<-SQL, *params)
        UPDATE users
          ('id', 'fname', 'lname')
        VALUES
          (?, ?, ?)
      SQL

    end

    self
  end

end
