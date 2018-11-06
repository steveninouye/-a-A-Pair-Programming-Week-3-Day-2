require_relative "questions_database"

class QuestionLike
  attr_accessor :title, :year, :playwright_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| QuestionLike.new(datum) }
  end

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def create
  end

  def update
  end
end