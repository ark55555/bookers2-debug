class Book < ApplicationRecord

	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :favorited_users, through: :favorites, source: :user
	has_many :book_comments, dependent: :destroy
	has_many :view_counts, dependent: :destroy

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

	def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

# 	検索機能のメソッド（現在未使用）
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

  # 検索機能（現在こちら利用）
  def self.search(search_word)
    Book.where(['category LIKE ?', "%#{search_word}%"])
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

  # 今日
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  # 昨日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  # 今週
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  # 前週
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

end