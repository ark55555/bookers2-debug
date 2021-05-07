class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  
  include JpPrefecture
  jp_prefecture :prefecture_code

  attachment :profile_image, destroy: false
  
  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end
  
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  def following?(other_user)
    active_relationships.find_by(followed_id:other_user.id)
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user).destroy
  end

  def self.search_for(search, word)
    if search == "perfect_match"
      @user = User.where(name: word)
    elsif search == "forward_match"
      @user = User.where("name LIKE ?", word + "%")
    elsif search == "backward_match"
      @user = User.where("name LIKE ?", "%" + word)
    else
      @user = User.where("name LIKE?", "%" + word + "%")
    end
  end
end
