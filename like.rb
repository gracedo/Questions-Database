class Like
  attr_accessor :id, :liker_id, :question_id

  def self.all
    likes = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    likes.map { |like| Like.new(like) }
  end

  def initialize(options = {})
    @id = options['id']
    @liker_id = options['liker_id']
    @question_id = options['question_id']
  end

  def self.find_by_id(id)
    like = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      question_likes.id = ?
    SQL
    Like.new(like[0])
  end

  def self.likers_for_question_id(question_id)
    likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_likes ql
      JOIN
        users ON ql.liker_id = users.id
      WHERE
        ql.question_id = ?
      SQL

    likers.map { |liker_data| User.new(liker_data) }
  end

  def self.num_likes_for_question_id(question_id)
    num_likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(liker_id)
      FROM
        question_likes ql
      JOIN
        questions ON ql.question_id = questions.id
      WHERE
        questions.id = ?
      GROUP BY
        questions.id
      SQL
    num_likes[0][0]
  end
end