require 'singleton'
require 'sqlite3'
require_relative 'questions'

class User
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    result.map { |result| User.new(result) }
    result.first
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

    result.map { |result| User.new(result) }
    result.first
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
end
