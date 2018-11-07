require_relative "questions_database"

class QuestionLike
  attr_accessor :user_id, :question_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| QuestionLike.new(datum) }
  end
  
  def self.likers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_likes
      JOIN
        users
      ON
        users.id = question_likes.user_id
      WHERE
        question_id = ?
    SQL
    # returning back users
    data.map{|datum| User.new(datum)}
  end
  
  def self.num_likes_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*) AS num_likes
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL
    
    data[0]['num_likes']
  end
  
  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions
      ON
        question_likes.question_id = questions.id
      WHERE
        user_id = ?
    SQL

    data.map{|datum| Question.new(datum)}
  end
  
  def self.most_liked_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT 
        questions.*
      FROM
        (SELECT
          question_id AS id
        FROM
          question_likes
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

end