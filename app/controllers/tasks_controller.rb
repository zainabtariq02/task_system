# frozen_string_literal: true

# Tasks Controller
class TasksController < ApplicationController
  load_and_authorize_resource
  
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.paginate(page: params[:page], per_page: 6)
    respond_to do |format|
      format.html
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    respond_to do |format|
      format.html
    end
  end

  # GET /tasks/new
  def new
    respond_to do |format|
      format.html
    end
  end

  # GET /tasks/1/edit
  def edit
    respond_to do |format|
      format.html
    end
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task.created_by_user_id = current_user.id
    @task.assignee_user_id   = current_user.id unless current_user.admin
   
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task is successfully created.' }
       
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task is successfully updated.' }
      
      else
        format.html { render :edit }
    
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  
  def destroy
    @task.destroy
    respond_to do |format|
      if @task.destroyed?
        format.html { redirect_to tasks_path, notice: 'Task is successfully destroyed.' }
      else
        format.html { redirect_to tasks_path, alert: 'Task could not be destroyed!' }
      end
    end
  end
  
  def in_progress
    respond_to do |format|
      if @task.can_transition? :in_progress
        @task.in_progress!
        format.html { redirect_to tasks_path, notice: 'Task status has been updated.' }
      else
        format.html { redirect_to tasks_path, alert: 'Task status could not be updated!' }
      end
    end
  end

  def complete
    respond_to do |format|
      if @task.can_transition? :complete
        @task.complete!
        format.html { redirect_to tasks_path, notice: 'Task status has been updated.' }
      else
        format.html { redirect_to tasks_path, alert: 'Task status could not be updated!' }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :details, :assignee_user_id, :reviewer_user_id, :created_by_user_id)
  end
    
end
