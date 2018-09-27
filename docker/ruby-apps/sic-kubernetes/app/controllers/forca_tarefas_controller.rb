class ForcaTarefasController < ApplicationController
  def index
    @forca_tarefas = ForcaTarefa.all.order(id: :desc)
  end

  def new
    @forca_tarefa = ForcaTarefa.new
  end

  def show
  end

  def create
    @forca_tarefa = ForcaTarefa.new(forca_tarefa_params)

    respond_to do |format|
      if @forca_tarefa.save
        format.html { redirect_to forca_tarefas_path, notice: 'Registro foi criado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @forca_tarefa.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @forca_tarefa.update(forca_tarefa_params)
        format.html { redirect_to forca_tarefas_path, notice: 'Registro atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @forca_tarefa.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @forca_tarefa.destroy
        format.html { redirect_to forca_tarefas_path, notice: 'Registro deletado com sucesso.' }
        format.json { head :no_content }
      else
        @foruns = Forum.all
        format.html { render action: 'index' }
        format.json { render json: @foruns.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def forca_tarefa_params
      params.require(:forca_tarefa).permit(:nome, :data_inicial, :data_final, :ativo)
    end
end
