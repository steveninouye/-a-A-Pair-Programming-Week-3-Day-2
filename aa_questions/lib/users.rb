require_relative "questions_database"
require_relative "questions"

class User < QuestionDB
  attr_accessor :id, :fname, :lname
  TABLE = 'users'

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end
  
  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, :fname => fname, :lname => lname)
      SELECT 
        *
      FROM 
        users
      WHERE 
        lname = :lname AND fname = :fname
    SQL
    
    User.new(data)
  end 
  
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        *
      FROM 
        users
      WHERE 
        id = ?
    SQL
    
    User.new(data)
  end 
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def authored_questions
    Question.find_by_author_id(@id)
  end 
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end 
  
  def follow_questions 
    QuestionFollow.followed_questions_for_user_id(@id)
  end 
  
  def average_karma
    data = QuestionsDatabase.instance.execute(<<-SQL, :author_id => author_id)
    SELECT 
      CAST(COUNT(question_likes.user_id) AS FLOAT) / COUNT (DISTINCT questions_asked_by_user.id)
    FROM
      (SELECT 
        *
      FROM 
        questions 
      WHERE 
        author_id = 1
      ) AS questions_asked_by_user
      LEFT JOIN 
        question_likes ON question_likes.question_id = questions_asked_by_user.id
    SQL
  end 
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
  
  def save
    QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    SQL
    
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end 
end