class SlocationsController < ApplicationController
  before_action :set_slocation, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    @slocations = Slocation.all.order("ascii(name)")
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @slocation = Slocation.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @slocation = Slocation.new(slocation_params)

    respond_to do |format|
      if @slocation.save
        format.html { redirect_to @slocation, notice: 'Story location was successfully created.' }
        format.json { render :show, status: :created, slocation: @slocation }
      else
        format.html { render :new }
        format.json { render json: @slocation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @slocation.update(slocation_params)
        format.html { redirect_to @slocation, notice: 'Story location was successfully updated.' }
        format.json { render :show, status: :ok, slocation: @slocation }
      else
        format.html { render :edit }
        format.json { render json: @slocation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @slocation.destroy
    respond_to do |format|
      format.html { redirect_to slocations_url, notice: 'Story Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_slocation
    @slocation = Slocation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def slocation_params
    params[:slocation].permit(:code, :name)
  end
end
