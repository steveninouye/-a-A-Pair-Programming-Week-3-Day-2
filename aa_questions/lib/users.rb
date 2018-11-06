require_relative "questions_database"
require_relative "questions"

class User
  attr_accessor :id, :fname, :lname

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
    data.map { |datum| User.new(datum) }
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
    data.map { |datum| User.new(datum) }
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
  
  def create
    
  end

  def update
  end
end