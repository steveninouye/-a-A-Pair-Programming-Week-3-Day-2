require_relative "questions_database"

class QuestionFollow
  attr_accessor :user_id, :question_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| QuestionFollow.new(datum) }
  end
  
  def self.followers_for_questions_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT 
        users.*
      FROM 
        question_follows
      JOIN
        users ON users.id = question_follows.user_id 
      WHERE 
        question_id = ?
    SQL
    
    data.map { |datum| User.new(datum) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT 
        questions.*
      FROM 
        question_follows
      JOIN
        questions ON questions.id = question_follows.question_id 
      WHERE 
        user_id = ?
    SQL
    
    data.map { |datum| Question.new(datum) }
  end 
  
  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT 
        questions.*
      FROM
        (SELECT
          question_id AS id
        FROM
          question_follows
        GROUP BY
          id
        ORDER BY
          COUNT(*) DESC
        LIMIT
          ?) AS best_questions
      JOIN
        questions
        ON questions.id = best_questions.id
    SQL
    data.map { |datum| Question.new(datum) }
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