class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
    
  def index
#    @tasks = Task.all
    # user_id: current_user.id
#    @tasks = current_user.tasks.order(created_at: :desc)
    # set_taskで共通化
    @tasks = current_user.tasks.recent
  end

  def show
#    @task = Task.find(params[:id])
#    @task = current_user.tasks.find(params[:id])
  end

  def new
    @task = Task.new
  end
  
  def create
#    @task = Task.new(task_params)
#    @task = Task.new(task_params.merge(user_id: current_user.id))
    @task = current_user.tasks.new(task_params)
    
    if @task.save
      Rails.application.config.custom_logger.debug "task: #{@task.attributes.inspect}"
#     redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました。"
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
#    @task = current_user.tasks.find(params[:id])
  end
  
  def update
#    task = current_user.tasks.find(params[:id])
    # set_taskで共通化するので、インスタンス変数に変更
    @task.update!(task_params) # taskへの代入とUPDATEを一括で行う
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
  end
  
  def destroy
#    task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
  end
  
  private
  
  def task_params
    params.require(:task).permit(:name, :description)
  end
  
  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
