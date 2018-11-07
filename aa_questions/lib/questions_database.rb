require 'sqlite3'
require 'singleton'
require 'active_support/inflector'
require_relative 'questions'
require_relative 'users'
require_relative 'replies'
require_relative 'question_follows'
require_relative 'question_likes'


class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class QuestionDB

  # def initialize
  # end 

  # def self.find_by_id(id)
  #   data = QuestionsDatabase.instance.execute(<<-SQL, TABLE, id)
  #     SELECT 
  #       *
  #     FROM 
  #       ?
  #     WHERE 
  #       id = ?
  #   SQL
  # 
  #   self.class.new(data)
  # end 

  # def self.make_string 
  #   "SELECT * FROM #{self.table}"
  # end 

  # def self.all 
  #   data = QuestionsDatabase.instance.execute(<<-SQL)
  #     SELECT
  #       *
  #     FROM
  #       #{TABLE}
  #   SQL
  # 
  #   data.map { |datum| self.class.new(datum) }
  # end
end 