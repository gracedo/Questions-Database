

class User
  attr_reader :fname, :lname, :id

  def self.all
    users = QuestionsDatabase.instance.execute("SELECT * FROM users")
    p users
    users.map { |user| User.new(user) }
  end

  def initialize(options={})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      users
    WHERE
      users.id = ?
    SQL
    User.new(user[0])
  end

  def self.find_by_name(name)
    users = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
      *
    FROM
      users
    WHERE
      users.fname = ? AND users.lname = ?
    SQL
    users.map { |user_data| User.new(user_data) }
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    Question.followed_questions_for_user_id(@id)
  end
end