class SplaceCategoriesController < ApplicationController
  before_action :set_splace_category, only: [:show, :edit, :update, :destroy]

  # GET /place_categories
  # GET /place_categories.json
  def index
    @splace_categories = SplaceCategory.all.order(:name)
  end

  # GET /place_categories/1
  # GET /place_categories/1.json
  def show
  end

  # GET /place_categories/new
  def new
    @splace_category = SplaceCategory.new
  end

  # GET /place_categories/1/edit
  def edit
  end

  # POST /place_categories
  # POST /place_categories.json
  def create
    @splace_category = SplaceCategory.new(splace_category_params)

    respond_to do |format|
      if @splace_category.save
        format.html { redirect_to @splace_category, notice: 'Story place category was successfully created.' }
        format.json { render :show, status: :created, location: @splace_category }
      else
        format.html { render :new }
        format.json { render json: @splace_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /place_categories/1
  # PATCH/PUT /place_categories/1.json
  def update
    respond_to do |format|
      if @splace_category.update(splace_category_params)
        format.html { redirect_to @splace_category, notice: 'Story place category was successfully updated.' }
        format.json { render :show, status: :ok, location: @splace_category }
      else
        format.html { render :edit }
        format.json { render json: @splace_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /place_categories/1
  # DELETE /place_categories/1.json
  def destroy
    @splace_category.destroy
    respond_to do |format|
      format.html { redirect_to splace_categories_url, notice: 'Story place category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_splace_category
      @splace_category = SplaceCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def splace_category_params
      params[:splace_category].permit(:code, :name)
    end
end
