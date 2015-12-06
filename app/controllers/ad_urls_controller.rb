class AdUrlsController < ApplicationController
  before_action :set_ad_url, only: [:show, :edit, :update, :destroy]

  # GET /ad_urls
  # GET /ad_urls.json
  def index
    @q = AdUrl.ransack(params[:q])
    @ad_urls = @q.result
    # @ad_urls = AdUrl.all
  end

  # GET /ad_urls/1
  # GET /ad_urls/1.json
  def show
  end

  # GET /ad_urls/new
  def new
    @ad_url = AdUrl.new
  end

  # GET /ad_urls/1/edit
  def edit
  end

  # POST /ad_urls
  # POST /ad_urls.json
  def create
    @ad_url = AdUrl.new(ad_url_params)

    respond_to do |format|
      if @ad_url.save
        format.html { redirect_to @ad_url, notice: 'Ad url was successfully created.' }
        format.json { render :show, status: :created, location: @ad_url }
      else
        format.html { render :new }
        format.json { render json: @ad_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ad_urls/1
  # PATCH/PUT /ad_urls/1.json
  def update
    respond_to do |format|
      if @ad_url.update(ad_url_params)
        format.html { redirect_to @ad_url, notice: 'Ad url was successfully updated.' }
        format.json { render :show, status: :ok, location: @ad_url }
      else
        format.html { render :edit }
        format.json { render json: @ad_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ad_urls/1
  # DELETE /ad_urls/1.json
  def destroy
    @ad_url.destroy
    respond_to do |format|
      format.html { redirect_to ad_urls_url, notice: 'Ad url was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ad_url
      @ad_url = AdUrl.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ad_url_params
      params.require(:ad_url).permit(:link, :position, :is_ad)
    end
end
