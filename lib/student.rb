require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    id, name, grade = row[0], row[1], row[2]
    new_student = Student.new
    new_student.id = id
    new_student.name = name
    new_student.grade = grade
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |info|
      self.new_from_db(info)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    info = DB[:conn].execute(sql, name).flatten
    self.new_from_db(info)
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
    sql = <<-SQL
      SELECT COUNT(*) FROM students WHERE grade = 9
    SQL

    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map do |info|
      self.new_from_db(info)
    end
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL

    DB[:conn].execute(sql, num).map do |info|
      self.new_from_db(info)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL

    self.new_from_db(DB[:conn].execute(sql).first)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    DB[:conn].execute(sql, grade).map do |info|
      self.new_from_db(info)
    end
  end

end
