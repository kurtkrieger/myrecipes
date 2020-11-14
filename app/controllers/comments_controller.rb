class CommentsController < ApplicationController
  def index
    @comments = Comment.paginate(page: params[:page], per_page: 2)
  end

end
