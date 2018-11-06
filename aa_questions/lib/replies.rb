require_relative "questions_database"

class Reply
  attr_accessor :id, :body, :question_id, :parent_id, :user_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end
  
  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, :user_id => user_id)
      SELECT 
        *
      FROM 
        replies
      WHERE 
        user_id = :user_id
    SQL
    
    data.map { |datum| Reply.new(datum) }
  end 
  
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        *
      FROM 
        replies
      WHERE 
        id = ?
    SQL
    
    data.map { |datum| Reply.new(datum) }
  end
    
  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, :question_id => question_id)
      SELECT 
        *
      FROM 
        replies
      WHERE 
        question_id = :question_id
    SQL
    
    data.map { |datum| Reply.new(datum) }
  end 
  
  def initialize(options)
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
  end
  
  def author
    User.find_by_user_id(@user_id)
  end

  def question
    Question.find_by_question_id(@question_id)
  end
  
  def parent_reply
    Reply.find_by_id(@parent_id)
  end
  
  def child_replies
    Reply.all.select{ |child_reply| child_reply.parent_id = id }
  end
  
  def create
  end

  def update
  end
end