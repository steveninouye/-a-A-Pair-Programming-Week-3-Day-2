require_relative "questions_database"

class Question
  attr_accessor :id, :title, :body, :author_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum) }
  end
  
  def self.find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, :author_id => author_id)
      SELECT 
        *
      FROM 
        questions 
      WHERE 
        author_id = :author_id
    SQL
    
    Question.new(data)
  end 
  
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, :id => id)
      SELECT 
        *
      FROM 
        questions 
      WHERE 
        id = :id
    SQL
    
    Question.new(data)
  end 

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
  
  def author
    User.find_by_id(@author_id)
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end

  def create
  end

  def update
  end
end