class PermissaoAcessosController < ApplicationController
  before_action :set_permissao_acesso, only: [:show, :edit, :update, :destroy, :atualizar]

  def index
    @colaboradores = Cfue.select('DISTINCT (pessoa_fisica_cpf), *').where("funcao_descricao = ? and ativo = ?", "Operador SIC", true)
    @tipos = ["Todos", "Expirados", "Ativos"]
  end

  def show
  end

  def new
    @permissao_acesso = PermissaoAcesso.new
  end

  def edit
  end

  def atualizar
    @permissao_acesso.update(data: Date.today+90)

    flash[:notice] = "Permissão atualizada com sucesso."
    redirect_to :back
  end

  def filtrar
    if params["usuario"].present?
      @colaboradores = Cfue.select('DISTINCT (pessoa_fisica_cpf), *').where("funcao_descricao = ? and ativo = ? and pessoa_fisica_nome = ?", "Operador SIC", true, params["usuario"])
    else
      @colaboradores = Cfue.select('DISTINCT (pessoa_fisica_cpf), *').where("funcao_descricao = ? and ativo = ?", "Operador SIC", true)
      #filtro data expiração
      if params["tipo"] != "Todos"
        if params["tipo"] == "Expirados"
          @colaboradores = Cfue.select('DISTINCT (pessoa_fisica_cpf), *').where("funcao_descricao = ? and ativo = ?", "Operador SIC", true)
          @expirados = PermissaoAcesso.where("data < ?", Date.today).pluck(:cpf)            
          @colaboradores = @colaboradores.where('pessoa_fisica_cpf in (?)', @expirados)
        else #caso "Ativos"
          @colaboradores = Cfue.select('DISTINCT (pessoa_fisica_cpf), *').where("funcao_descricao = ? and ativo = ?", "Operador SIC", true)
          @ativos = PermissaoAcesso.where("data > ?", Date.today).pluck(:cpf)
          @colaboradores = @colaboradores.where('pessoa_fisica_cpf in (?)', @ativos)      
        end
      end
    end
  end

  def json_autocomplete_usuario
    search = enhancement_ilike('pessoa_fisica_nome', params["term"])
    @usuarios = Cfue.where(search).distinct(:pessoa_fisica_nome)
    @usuarios = @usuarios.where(ativo: true, funcao_descricao: "Operador SIC").pluck(:pessoa_fisica_nome)
    
    respond_to do |format|
      format.html { render json: @usuarios }
    end
  end  

  def liberar
    @permissao_acesso = PermissaoAcesso.new
    @permissao_acesso["cpf"] = params["cpf"]
    @permissao_acesso["defensor"] = get_cpf
    @permissao_acesso["data"] = Date.today+90
    @permissao_acesso.save

    flash[:notice] = "Permissão garantida com sucesso."
    redirect_to :back
  end  

  def update
    respond_to do |format|
      if @permissao_acesso.update(permissao_acesso_params)
        format.html { redirect_to @permissao_acesso, notice: 'Permissão de Acesso atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @permissao_acesso.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @permissao_acesso.destroy
    flash[:alert] = "Permissão revogada com sucesso."

    respond_to do |format|
      format.html { redirect_to permissao_acessos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permissao_acesso
      @permissao_acesso = PermissaoAcesso.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permissao_acesso_params
      params.require(:permissao_acesso).permit(:cpf, :data)
    end
end