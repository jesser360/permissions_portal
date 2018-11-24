class GroupsController < ApplicationController
  require 'httparty'
  include HTTParty

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group_id = params[:id]
    @group_response = HTTParty.get("https://rails-api-ipo.herokuapp.com/api/v1/groups/#{@group_id}.json")
    @group = {}
    @users =[]
    @group['id']=(@group_response['id'])
    @group['group_name']=(@group_response['group_name'])
    @group['group_permissions']=(@group_response['group_permissions'])
    @group['company_id']=(@group_response['company_id'])
    @users = @group_response['users']
  end

  # GET /groups/new
  def new
    @group = Group.new
    @company_id = params[:company_id]
    @company_name = params[:company_name]
  end

  # GET /groups/1/edit
  def edit
    @group = Group.new
    @group_id = params[:id]
    @group_response = HTTParty.get("https://rails-api-ipo.herokuapp.com/api/v1/groups/#{@group_id}.json")
    @group.id=(@group_response['id'])
    @group.group_name=(@group_response['group_name'])
    @group.group_permissions=(@group_response['group_permissions'])
    @group.company_id=(@group_response['company_id'])
  end

  # POST /groups
  # POST /groups.json
  def create
    @group_params = group_params.to_json
    @reponse = HTTParty.post("https://rails-api-ipo.herokuapp.com/api/v1/groups.json",
    :body => @group_params,
    :headers => { 'Content-Type' => 'application/json' } )
    respond_to do |format|
        format.html { redirect_to '/groups/'+(@reponse['id'].to_s), notice: 'Group was successfully created.' }
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    @group_id = group_params[:group_id]
    puts group_params
    puts "PARAMS"
    @reponse = HTTParty.put("https://rails-api-ipo.herokuapp.com/api/v1/groups/#{@group_id}.json",
    :body => {:group_name => group_params[:group_name], :group_permissions => group_params[:group_permissions]}.to_json,
    :headers => { 'Content-Type' => 'application/json' } )
    respond_to do |format|
        format.html { redirect_to '/groups/'+(@reponse['id'].to_s), notice: 'Group was successfully created.' }
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.fetch(:group, {}).permit(:group_name, :group_permissions, :company_id, :group_id)
    end
end
