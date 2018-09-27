class VinculoDefensoresController < ApplicationController
  before_action :set_vinculo_defensor, only: [:show, :edit, :update, :destroy]
  before_action :set_assistido, except: [:new]

  def new
    @vinculo_defensor = VinculoDefensor.new
  end

  def edit; end

  def create
    @vinculo_defensor = VinculoDefensor.new(vinculo_defensor_params)
    respond_to do |format|
      if @vinculo_defensor.save
        format.html { redirect_to assistido_path(@vinculo_defensor.assistido), sucess: "Vinculação realizada com sucesso." }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @vinculo_defensor = VinculoDefensor.find(params[:id])
    respond_to do |format|
      if @vinculo_defensor.update(vinculo_defensor_params)
        format.html { redirect_to assistido_path(@vinculo_defensor.assistido), sucess: "Vinculação realizada com sucesso." }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @vinculo_defensor = VinculoDefensor.find(params[:id])
    respond_to do |format|
      if @vinculo_defensor.destroy
        format.html { redirect_to assistido_path params[:assistido_id] }
      else
        @vinculo = VinculoDefensor.all
        format.html { render action: 'index' }
      end
    end
  end

  private

  def set_vinculo_defensor
    @vinculo_defensor = VinculoDefensor.find(params[:id])
  end

  def set_assistido
    params[:assistido_id] = @vinculo_defensor.assistido_id
  end

  def vinculo_defensor_params
    params.require(:vinculo_defensor).permit(:assistido_id, :defensor_cpf, :acompanhar_processo, :acompanhar_inquerito)
  end
end
