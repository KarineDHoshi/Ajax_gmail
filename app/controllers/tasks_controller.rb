class TasksController < ApplicationController
  before_action :authenticate_user!
    def new
      @categories = Category.all
    end
  
    def create
      @task = Task.new(task_params)
      @category = Category.find(category_params)
      @task.category = @category
      if @task.save
        # adding 'respond_to |format| ... ' for AJAX to work and read our js.erb file instead of .html one if possible (some browser may not support it)
        respond_to do |format|
          format.html { redirect_to root_path }
          format.js { }
        end
        flash[:notice] = "Task created"
      else
        respond_to do |format|
          format.html { redirect_to root_path }
          format.js { }
        end
        flash[:notice] = "Please try again"
      end
    end
  
    def edit
      @task = Task.find(params[:id])
      @categories = Category.all
  
    end
  
    def update
      @task = Task.find(params[:id])
      
      # For the checkbox to work, I guess we need to make it possible to change the status from true to false and vice versa:
      if @task.status # <= same as "if @task.status == true"
        @task.status = false
      elsif @task.status = false
        @task.status = true
      end
  
      @task.update(task_params)
      redirect_to tasks_path
      flash[:notice] = "Task edited"
    end
  
    def index
      @tasks = Task.all
    end
  
    def destroy
      @task = Task.find(params[:id])
      @task.destroy
      respond_to do |format|
        format.html { redirect_to books_path }
        format.js { }
      end
      redirect_to root_path, :notice => "The task has been deleted" # just in case, but the redirection is also taken care of by the destroy.js.erb file.
    end
  
  
    private
  
    def task_params
      params.permit(:title, :deadline, :description)
    end
  
    def category_params
      params.require(:Category)
    end
  
  end