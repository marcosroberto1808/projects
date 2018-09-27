class ForunsController < ApplicationController
  before_action :set_forum, only: [:show, :edit, :update, :destroy]
  before_action :cidades, only: [:new, :create, :edit, :update]


  def index
    @foruns = Forum.all.order(:nome)
  end

  def show
  end

  def new
    @forum = Forum.new
  end

  def edit
    @cidades = Cidade.all
  end

  def create
    @forum = Forum.new(forum_params)

    respond_to do |format|
      if @forum.save
        format.html { redirect_to @forum, notice: 'Foro foi criado com sucesso.' }
        format.json { render action: 'show', status: :created, location: @forum }
      else
        format.html { render action: 'new' }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @forum.update(forum_params)
        format.html { redirect_to @forum, notice: 'Foro atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    
    respond_to do |format|
      if @forum.destroy
        format.html { redirect_to @forum, notice: 'Foro foi deletado com sucesso.' }
        format.json { head :no_content }
      else
        @foruns = Forum.all
        format.html { render action: 'index' }
        format.json { render json: @foruns.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def cidades
      @cidades = Cidade.all      
    end

    def set_forum
      @forum = Forum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forum_params
      params.require(:forum).permit(:nome, :cidade, :uf)
    end
end
