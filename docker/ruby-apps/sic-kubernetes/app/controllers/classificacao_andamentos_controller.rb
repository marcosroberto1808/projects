class ClassificacaoAndamentosController < ApplicationController
  before_action :set_classificacao_andamento, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @classificacao_andamentos = ClassificacaoAndamento.all
    respond_with(@classificacao_andamentos)
  end

  def show
    respond_with(@classificacao_andamento)
  end

  def new
    @classificacao_andamento = ClassificacaoAndamento.new
    respond_with(@classificacao_andamento)
  end

  def edit
  end

  def create
    @classificacao_andamento = ClassificacaoAndamento.new(classificacao_andamento_params)
    @classificacao_andamento.save
    respond_with(@classificacao_andamento)
  end

  def update
    @classificacao_andamento.update(classificacao_andamento_params)
    respond_with(@classificacao_andamento)
  end

  def destroy
    @classificacao_andamento.destroy
    respond_with(@classificacao_andamento)
  end

  private
    def set_classificacao_andamento
      @classificacao_andamento = ClassificacaoAndamento.find(params[:id])
    end

    def classificacao_andamento_params
      params.require(:classificacao_andamento).permit(:descricao)
    end
end
