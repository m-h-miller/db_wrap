require 'singleton'
require 'sqlite3'
require_relative 'questions'


class Question
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    result.map { |result| Question.new(result) }
    result.first
  end

  def self.find_by_author_id(author_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    result.map { |result| Question.new(result) }
    result.first
  end

  attr_accessor :id, :title, :body, :author_id
  def initialize(options = {})
    @id, @title, @body, @author_id =
      options.values_at('id', 'title', 'body', 'author_id')
  end

  def author
    User.find_by_id(self.author_id)
  end

  def replies
    Reply.find_by_question_id(self.id)
  end
end
