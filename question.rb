require 'singleton'
require 'sqlite3'
require_relative 'questions'


class Question
  TABLE = 'questions'

  def self.find_by_author_id(author_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    result.map { |result| Question.new(result) }.first
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
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

  def followers
    QuestionFollow.followers_for_question_id(self.id)
  end

  def likers
    QuestionLike.likers_for_question_id(self.id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end

  def save
    if self.id.nil?
      params = [self.title, self.body, self.author_id]
      QuestionsDatabase.instance.execute(<<-SQL, *params)
      INSERT INTO questions
        ('title', 'body', 'author_id')
      VALUES
          (?, ?, ?)
      SQL
    else
      params = [self.id, self.title, self.body, self.author_id]
      QuestionsDatabase.instance.execute(<<-SQL, *params)
      UPDATE questions
        ('id', 'title', 'body', 'author_id')
      VALUES
          (?, ?, ?, ?)
      SQL
    end

    self
  end
end
