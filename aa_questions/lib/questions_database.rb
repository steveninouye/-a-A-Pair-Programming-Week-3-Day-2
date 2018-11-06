require 'sqlite3'
require 'singleton'
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