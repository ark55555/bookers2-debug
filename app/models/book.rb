class Book < ApplicationRecord

	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :favorited_users, through: :favorites, source: :user
	has_many :book_comments, dependent: :destroy

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

	def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

# 	検索機能のメソッド
	def self.search_for(search, word)
    if search == "perfect_match"
      @book = Book.where(title: "#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE ?", word + "%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE ?", "%" + word)
    else
      @book = Book.where("title LIKE?", "%" + word + "%")
    end
  end
  
  # 週間いいねランキング(現在90日で設定)
  def self.week_ranks
    from = Time.current.at_beginning_of_day - 90.day 
    to = Time.current.at_end_of_day
    Book.includes(:favorited_users).where(created_at: from...to).
      sort {|a,b| 
        b.favorited_users.size <=> 
        a.favorited_users.size
      }
  end

end