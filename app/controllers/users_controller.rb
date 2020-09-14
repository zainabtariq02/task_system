# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
 
  # GET /users
  # GET /users.json
  def index
    # @users = User.all
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    respond_to do |format|
      format.html
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user       = User.new(user_params)
    @user.admin = false
    @user.skip_password_validation = true
    @user.skip_confirmation!

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User is successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User is successfully updated.' }
      else
        format.html { render :edit }

      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to users_path, notice: 'User is successfully destroyed.' }
      else
        format.html { redirect_to users_path, alert: @user.errors[:base][0] }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :name)
  end
end

