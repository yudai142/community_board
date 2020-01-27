class CommentsController < ApplicationController

  def new
    @topic = Topic.find(params[:topic_id])
    @comment = Comment.new
  end

  def create
    @comment = Comment.create!(comment_params)
    topic_update = Topic.find(params[:topic_id])
    topic_update.touch
    topic_update.updated_at
    redirect_to topic_path(params[:topic_id]), method: :get
  end


  private

  def comment_params
    params.require(:comment).permit(:content, :image).merge(topic_id: params[:topic_id], user_id: current_user.id)
  end
end
