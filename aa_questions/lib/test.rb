require 'active_support/inflector'
require 'byebug'
class QuestionDB

  def initialize
  end 

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT 
        *
      FROM 
        #{self.to_s.tableize}
      WHERE 
        #{id.to_s.tableize}
    SQL
  
    self.new(data)
  end 

  def self.all 
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.to_s.tableize}
    SQL
  
    data.map { |datum| self.new(datum) }
  end
end 