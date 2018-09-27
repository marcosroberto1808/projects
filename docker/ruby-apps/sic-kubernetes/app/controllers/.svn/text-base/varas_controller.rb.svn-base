class VarasController < ApplicationController
  before_action :set_vara, only: [:show, :edit, :update, :destroy]
  before_action :foruns, only: [:new, :create, :edit, :update]

  def index
  end

  def show
  end

  def new
    @vara = Vara.new
  end

  def edit
  end

  def create
    @vara = Vara.new(vara_params)

    respond_to do |format|
      if @vara.save
        format.html { redirect_to @vara, notice: 'Vara  criada com sucesso.' }
        format.json { render action: 'show', status: :created, location: @vara }
      else
        format.html { render action: 'new' }
        format.json { render json: @vara.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @vara.update(vara_params)
        format.html { redirect_to @vara, notice: 'Vara atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vara.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @vara.destroy
        format.html { redirect_to varas_url }
        format.json { head :no_content }
      else
        @varas = Vara.all
        format.html { render action: 'index' }
        format.json { render json: @vara.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vara
      @vara = Vara.find(params[:id])
    end

    def foruns
      @foruns = Forum.all
    end    

    # Never trust parameters from the scary internet, only allow the white list through.
    def vara_params
      params.require(:vara).permit(:nome, :forum_id)
    end
end
