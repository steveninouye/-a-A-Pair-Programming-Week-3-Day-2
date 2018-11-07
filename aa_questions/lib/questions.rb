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
  
  def self.most_followed(n)
    Question.most_followed_questions(n)
  end
  
  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end 

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
  
  def table 
    'questions'
  end 
  
  def author
    User.find_by_id(@author_id)
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
  
  def followers 
    QuestionFollow.followers_for_questions_id(@id)
  end 
  
  def likers
    QuestionLike.likers_for_question_id(@id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
  
  def save
    QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.author_id)
      INSERT INTO
        questions (title, body, author_id)
      VALUES
        (?, ?, ?)
    SQL
    
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end 
end