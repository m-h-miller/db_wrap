require 'singleton'
require 'sqlite3'
require_relative 'questions'

class Reply
  TABLE = 'replies'

  def self.find_by_user_id(user_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        author_id = ?
    SQL

    result.map { |result| Reply.new(result) }
  end

  def self.find_by_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    result.map { |result| Reply.new(result) }
  end

  attr_accessor :id, :subject_question_id, :parent_reply_id, :body, :author_id

  def initialize(options = {})
    @id, @subject_question_id, @parent_reply_id, @body, @author_id =
      options.values_at('id', 'subject_question_id', 'parent_reply_id', 'body', 'author_id')
  end

  def author
    User.find_by_id(self.author_id)
  end

  def question
    Question.find_by_id(self.subject_question_id)
  end

  def parent_reply
    Reply.find_by_id(self.parent_reply_id)
  end

  def child_replies
    result = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = ?
    SQL

    result.map { |result| Reply.new(result) }
  end

  def save
    if self.id.nil?
      params = [self.subject_question_id, self.parent_reply_id,
        self.body, self.author_id]
      QuestionsDatabase.instance.execute(<<-SQL, *params)
      INSERT INTO replies
        ('subject_question_id','parent_reply_id', 'body', 'author_id')
      VALUES
          (?, ?, ?, ?)
      SQL
    else
      params = [self.id, self.subject_question_id, self.parent_reply_id,
        self.body, self.author_id]
      QuestionsDatabase.instance.execute(<<-SQL, *params)
      UPDATE replies
        ('id', 'subject_question_id','parent_reply_id', 'body', 'author_id')
      VALUES
          (?, ?, ?, ?, ?)
      SQL
    end

    self
  end

end
