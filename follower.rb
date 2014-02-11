class Follower
  attr_reader :id, :question_id, :follower_id

  def self.all
    followers = QuestionsDatabase.instance.execute("SELECT * FROM question_followers")
    followers.map { |follower| Follower.new(follower) }
  end

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @follower_id = options['follower_id']
  end

  def self.find_by_id(id)
    follower = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_followers
    WHERE
      question_followers.id = ?
    SQL
    Follower.new(follower[0])
  end

  def self.followers_for_question_id(id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      users.*
    FROM
      question_followers qf
    JOIN
      users ON qf.follower_id = users.id
    WHERE
      qf.question_id = ?
    SQL

    followers.map { |user_data| User.new(user_data) }
  end

  def self.followed_questions_for_user_id(id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      questions.*
    FROM
      question_followers qf
    JOIN
      questions ON qf.question_id = questions.id
    WHERE
      qf.follower_id = ?
    SQL

    questions.map { |question_data| Question.new(question_data) }
  end

  def self.most_followed_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      questions.*
    FROM
      question_followers qf
    JOIN
      questions ON qf.question_id = questions.id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(qf.question_id) DESC
    SQL

    top_q = questions.map { |question_data| Question.new(question_data) }
    top_q.slice!(0...n)
  end
end

