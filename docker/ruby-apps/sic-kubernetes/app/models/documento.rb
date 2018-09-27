class Documento < ActiveRecord::Base
  belongs_to :tipo_documento
  belongs_to :assistido
  belongs_to :inquerito_policial
  belongs_to :processo_judicial
  belongs_to :classificacao_documento

  validates_presence_of :nome_url, message: ": Nenhum arquivo foi selecionado."
  validates_presence_of :data, message: ": O campo tem que ser preenchido."
  validates_presence_of :classificacao_documento_id, message: ": Nenhuma Classificação de Documento Disponível/Selecionada."

  def tipo_documento
    TipoDocumento.find(self.classificacao_documento.tipo_documento_id)
  end

  def get_path
    path = "#{PATH_DOCS_SIC}/documentos/#{self.assistido_id}/"
    case self.tipo_documento.descricao
      when 'Pessoal' then path + "pessoais/#{self.nome_url}"
      when 'Extrajudicial' then path + "extrajudiciais/#{self.nome_url}"
      when 'Processo' then path + "processos/#{self.processo_judicial_id}/#{self.nome_url}"
      when 'Inquérito' then path + "inqueritos/#{self.inquerito_policial_id}/#{self.nome_url}"
      else nil
    end
  end

  def duplicar_arquivo(new_path_file)
    file = self.get_path
    if File.exist?(file)
      FileUtils.mkdir_p(File.dirname(new_path_file))
      FileUtils.cp(file, new_path_file)
    end
  end
end
