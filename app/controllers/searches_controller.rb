class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @book = Book.new
    @books = Book.search(params[:keyword])
    # @range = params[:range]
    # @word = params[:word]
    # @search = params[:search]

    # if @range == "User"
      # @users = User.search_for(@search, @word)
    # else
      # @books = Book.search_for(@search, @word)
    # end
  end
end
