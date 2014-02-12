class Reply
  attr_accessor :id, :subject_question_id, :parent_reply_id, :author_id, :body

  def self.all
    replies = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    replies.map { |reply| Reply.new(reply) }
  end

  def initialize(options = {})
    @id = options['id']
    @subject_question_id = options['subject_question_id']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
    @body = options['body']
  end

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.id = ?
    SQL
    Reply.new(reply[0])
  end

  def self.find_by_question_id(id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.subject_question_id = ?
    SQL
    replies.map { |reply_data| Reply.new(reply_data) }
  end

  def self.find_by_user_id(id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.author_id = ?
    SQL
    replies.map { |reply_data| Reply.new(reply_data) }
  end

  def author
    @author_id
  end

  def question
    @subject_question_id
  end

  def parent_reply
    @parent_reply_id
  end

  def child_replies
    replies = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.parent_reply_id = ?
    SQL
    replies.map { |reply_data| Reply.new(reply_data) }
   end

   def save
     if self.id.nil?
       params = [@subject_question_id, @parent_reply_id, @author_id, @body]
       QuestionsDatabase.instance.execute(<<-SQL, *params)

       INSERT INTO
         replies(subject_question_id, parent_reply_id, author_id, body)
       VALUES
         (?, ?, ?, ?)
       SQL
       @id = QuestionsDatabase.instance.last_insert_row_id
     else
       params = [@title, @body, @user_id, @id]
       QuestionsDatabase.instance.execute(<<-SQL, *params)

       UPDATE
         replies(subject_question_id, parent_reply_id, author_id, body)
       SET
         subject_question_id = ?, parent_reply_id = ?, author_id = ?, body = ?
       WHERE
         replies.id = ?
       SQL
       nil
     end
end
