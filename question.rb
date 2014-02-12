class Question
  attr_accessor :id, :title, :body, :user_id

  def self.all
    questions = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    questions.map { |question| Question.new(question) }
  end

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      questions
    WHERE
      questions.id = ?
    SQL
    Question.new(question[0])
  end

  def self.find_by_author_id(id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      questions
    WHERE
      questions.user_id = ?
    SQL
    questions.map { |question_data| Question.new(question_data) }
  end

  def author
    @user_id
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    Follower.followers_for_question_id(@id)
  end

  def self.most_followed(n)
    Follower.most_followed_questions(n)
  end

  def likers
    Like.likers_for_question_id(@id)
  end

  def num_likes
    Like.num_likes_for_question_id(@id)
  end

  def self.most_liked(n)
    Like.most_liked_questions(n)
  end

  def save
    if self.id.nil?
      params = [@title, @body, @user_id]
      QuestionsDatabase.instance.execute(<<-SQL, *params)

      INSERT INTO
        questions(title, body, user_id)
      VALUES
        (?, ?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      params = [@title, @body, @user_id, @id]
      QuestionsDatabase.instance.execute(<<-SQL, *params)

      UPDATE
        questions(title, body, user_id)
      SET
        title = ?, body = ?, user_id = ?
      WHERE
        questions.id = ?
      SQL
      nil
    end
  end
end
