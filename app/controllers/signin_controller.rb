class SigninController < ApplicationController
  def index
    @users = Author.all
  end

  def new
    @user = Author.new
  end

  def create
    @newuser = Author.new(user_params)

    respond_to do |format|
      if @newuser.save
        format.html do
          redirect_to @newuser, notice: '가입 was successfully created.'
        end
        format.json { render :show, status: :created, location: @newuser }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @newuser.errors, status: :unprocessable_entity
        end
      end
    end

    SlackAlertModule.user_signin(user_params)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = Author.find_by(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.permit(:first_name, :last_name, :date_of_birth)
  end
end
