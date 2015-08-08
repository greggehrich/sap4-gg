class HoteljunksController < ApplicationController
  before_action :set_hoteljunk, only: [:show, :edit, :update, :destroy]

  # GET /hoteljunks
  # GET /hoteljunks.json
  def index
    @hoteljunks = Hoteljunk.all
  end

  # GET /hoteljunks/1
  # GET /hoteljunks/1.json
  def show
  end

  # GET /hoteljunks/new
  def new
    @hoteljunk = Hoteljunk.new
  end

  # GET /hoteljunks/1/edit
  def edit
  end

  # POST /hoteljunks
  # POST /hoteljunks.json
  def create
    @hoteljunk = Hoteljunk.new(hoteljunk_params)

    respond_to do |format|
      if @hoteljunk.save
        format.html { redirect_to @hoteljunk, notice: 'Hoteljunk was successfully created.' }
        format.json { render :show, status: :created, location: @hoteljunk }
      else
        format.html { render :new }
        format.json { render json: @hoteljunk.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hoteljunks/1
  # PATCH/PUT /hoteljunks/1.json
  def update
    respond_to do |format|
      if @hoteljunk.update(hoteljunk_params)
        format.html { redirect_to @hoteljunk, notice: 'Hoteljunk was successfully updated.' }
        format.json { render :show, status: :ok, location: @hoteljunk }
      else
        format.html { render :edit }
        format.json { render json: @hoteljunk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hoteljunks/1
  # DELETE /hoteljunks/1.json
  def destroy
    @hoteljunk.destroy
    respond_to do |format|
      format.html { redirect_to hoteljunks_url, notice: 'Hoteljunk was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hoteljunk
      @hoteljunk = Hoteljunk.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hoteljunk_params
      params.require(:hoteljunk).permit(:name)
    end
end
