class UsersController < ApplicationController

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user_id = params[:id]
    @user_response = HTTParty.get("https://rails-api-ipo.herokuapp.com/api/v1/users/#{@user_id}.json")
    @user = {}
    @user['id']=(@user_response['id'])
    @user['name']=(@user_response['name'])
    @user['email']=(@user_response['email'])
    @user['user_permissions']=(@user_response['user_permissions'])
    @user['group_id']=(@user_response['group_id'])
  end

  # GET /users/new
  def new
    @user = User.new
    @group_id = params[:group_id]
    @group_name = params[:group_name]
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user_params = user_params.to_json
    @reponse = HTTParty.post("https://rails-api-ipo.herokuapp.com/api/v1/users.json",
    :body => @user_params,
    :headers => { 'Content-Type' => 'application/json' } )
    puts "RESPONSE ID"
    puts @reponse
    respond_to do |format|
        format.html { redirect_to '/users/'+(@reponse['id'].to_s), notice: 'Group was successfully created.' }
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.fetch(:user, {}).permit(:name, :email, :password_digest, :user_permissions, :group_id)
    end
end
