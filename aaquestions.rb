require 'singleton'
require 'sqlite3'
load './question.rb'
load './user.rb'
load './follower.rb'
load './reply.rb'
load './like.rb'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("questions.db")
    self.results_as_hash = true
  end
end
