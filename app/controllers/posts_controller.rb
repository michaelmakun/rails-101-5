class PostsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :authenticate_user!, :only => [:edit, :update, :destroy]

  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end

  def edit
    set_PostGroup_and_check_permission
  end

  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user

    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def update

    set_PostGroup_and_check_permission

    if @post.update(post_params)
      redirect_to account_posts_path, notice: "Post Update Success"
    else
      render :edit
    end
  end

  def destroy

    set_PostGroup_and_check_permission

    @post.destroy
    redirect_to account_posts_path, alert: "Post Deleted"
  end


  private
  def set_PostGroup_and_check_permission
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "You have no permission."
    end
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
