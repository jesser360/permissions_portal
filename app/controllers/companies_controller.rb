class CompaniesController < ApplicationController
  require 'httparty'
  include HTTParty
  skip_before_action :verify_authenticity_token

  # GET /companies
  # GET /companies.json
  def index
    @response = HTTParty.get("https://rails-api-ipo.herokuapp.com/api/v1/companies.json")
    @companies = []
    @response.each do |comp|
      @companies.push(comp)
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @company_id = params[:id]
    @comp_response = HTTParty.get("https://rails-api-ipo.herokuapp.com/api/v1/companies/#{@company_id}.json")
    @company = {}
    @groups = []
    @company['id']=(@comp_response['id'])
    @company['company_name']=(@comp_response['company_name'])
    @groups = @comp_response['groups']
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
    @company = Company.new
    @company_id = params[:id]
    @comp_response = HTTParty.get("https://rails-api-ipo.herokuapp.com/api/v1/companies/#{@company_id}.json")
    @company.id=(@comp_response['id'])
    @company.company_name=(@comp_response['company_name'])
  end

  # POST /companies
  # POST /companies.json
  def create
    @company_params = company_params.to_json
    @reponse = HTTParty.post("https://rails-api-ipo.herokuapp.com/api/v1/companies.json",
    :body => @company_params,
    :headers => { 'Content-Type' => 'application/json' } )
    respond_to do |format|
        format.html { redirect_to '/companies/'+(@reponse['id'].to_s), notice: 'Company was successfully created.' }
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    @company_id = company_params[:company_id]
    @reponse = HTTParty.put("https://rails-api-ipo.herokuapp.com/api/v1/companies/#{@company_id}.json",
    :body => {:company_name => company_params[:company_name]}.to_json,
    :headers => { 'Content-Type' => 'application/json' } )
    respond_to do |format|
        format.html { redirect_to '/companies/'+(@reponse['id'].to_s), notice: 'Company was successfully created.' }
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.fetch(:company, {}).permit(:company_name, :company_id)
    end
end
