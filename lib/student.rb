require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
      SELECT * FROM students
    SQL

    sql = DB[:conn].execute(sql)
    # remember each row should be a new instance of the Student class
    sql.map do |student|
      new_from_db(student)
    end

  end

  def self.find_by_name(name)
    
    # find the student in the database given a name
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL

    # return a new instance of the Student class
    DB[:conn].execute(sql, name).map do |row_column|
      self.new_from_db(row_column)
    end.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    all.select {|student| student.grade == "9"}
  end

  def self.students_below_12th_grade
    all.select {|student| student.grade != "12"}
  end

  def self.first_X_students_in_grade_10(quantity)
    all.select {|student| student.grade == "10"}[0..(quantity - 1)]
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(grade)
    all.select {|student| student.grade == "#{grade}"}
  end

end
