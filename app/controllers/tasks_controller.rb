class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(task_params)
    
    if @task.save
#     redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました。"
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    task = Task.find(params[:id])
    task.update!(task_params) # taskへの代入とUPDATEを一括で行う
    redirect_to tasks_url, notice: "タスク「#{task.name}」を更新しました。"
  end
  
  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to tasks_url, notice: "タスク「#{task.name}」を削除しました。"
  end
  
  private
  
  def task_params
    params.require(:task).permit(:name, :description)
  end
end
