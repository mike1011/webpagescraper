class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]
  require 'rubygems'
require 'nokogiri'
require 'open-uri'

  # GET /campaigns
  # GET /campaigns.json
  def index
    @campaigns = Campaign.all
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
  end

  # GET /campaigns/new
  def new
    @campaign = Campaign.new
  end

  # GET /campaigns/1/edit
  def edit
  end

  # POST /campaigns
  # POST /campaigns.json
  def create

    @url=params[:campaign][:url]
    @webpage_title= URI.parse(@url).host
    doc = Nokogiri::HTML(open(@url))
    @campaign_titles=[]
    @campaign_owners=[] ##//*[@class="f-fw-thin f-width-100"]/div[@class='f-ilb f-m-r-xsmall']
    @campaign_categories=[]
    @campaign_total_raised=[]
    @final_array=[]
     ##row.xpath('./td').each do |td|
        doc.search('h4.f-width-100').each do |title|
           @campaign_titles <<  title.text
         end  
   
         doc.xpath('//*[@class="f-ilb f-m-r-xsmall"]').each do |owner|
           @campaign_owners <<  owner.text
         end 


        doc.search('//*[@class="f-ilb f-fc-medium"]').each do |cat|
           @campaign_categories <<  cat.text
         end          


        doc.search('//*[@class="f-ilb"]').each do |amt|
           @campaign_total_raised <<  amt.text
         end     
    
    @final_array << [@campaign_titles,@campaign_owners,@campaign_categories,@campaign_total_raised]
    @final_array[0][1].each_with_index do |_,index|
     @campaign=Campaign.new(:title=>@final_array[0][0][index],:owner=>@final_array[0][1][index],:category=>@final_array[0][2][index],:raised_amount=>@final_array[0][3][index].split("/").first,:total_amount=>@final_array[0][3][index].split("/").second)
     @campaign.save! unless Campaign.find_by_title(@campaign.title).present?
    end
    
    respond_to do |format|
      @campaigns = Campaign.all
      if @campaigns.present?        
        format.html { render :index } ##{ redirect_to '/index', notice: 'Campaign was successfully created.' }
        ##format.json { render :index, status: :created, location: @campaign }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaigns/1
  # PATCH/PUT /campaigns/1.json
  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params.require(:campaign).permit(:title, :description, :other_links, :owner, :category, :raised_amount, :total_amount)
    end
end
