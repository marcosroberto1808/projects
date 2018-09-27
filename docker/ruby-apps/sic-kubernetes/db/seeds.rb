# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#PESSOAIS
ClassificacaoDocumento.create([
								{descricao: 'Documento de Identidade Civil', tipo_documento_id: 1}, 
								{descricao: 'CPF', tipo_documento_id: 1}, 
								{descricao: 'Comprovante de Endereço', tipo_documento_id: 1}, 
								{descricao: 'Certidão de Antecedentes Criminais', tipo_documento_id: 1}, 
								{descricao: 'Certidão de Nascimento dos Filhos', tipo_documento_id: 1}, 
								{descricao: 'Exame de Gravidez', tipo_documento_id: 1}, 
								{descricao: 'Documentação Médica', tipo_documento_id: 1}, 
								{descricao: 'Declaração de Escolaridade', tipo_documento_id: 1}, 
								{descricao: 'Declaração de Trabalho', tipo_documento_id: 1}, 
								{descricao: 'Outros', tipo_documento_id: 1}, 																																																																
								])

#Extrajudiciais
ClassificacaoDocumento.create([
								{descricao: 'Oficío', tipo_documento_id: 2}, 
								{descricao: 'E-mail', tipo_documento_id: 2}, 
								])

#Processo: 
ClassificacaoDocumento.create([
								{descricao: 'Anexo de Andamento', tipo_documento_id: 3}, 
								])

#Inquérito: 
ClassificacaoDocumento.create([
								{descricao: 'Pedido de Arbitramento de Fiança', tipo_documento_id: 4}, 
								{descricao: 'Pedido de Restituição de Bens', tipo_documento_id: 4}, 
								{descricao: 'Solicitação de Atendimento Médico', tipo_documento_id: 4}, 
								{descricao: 'Solicitação de Escolta', tipo_documento_id: 4}, 
								{descricao: 'Solicitação de Cópia', tipo_documento_id: 4},
								{descricao: 'Inquérito Policial', tipo_documento_id: 4}, 																																																																
								])

#Classificação Andamento Processo
ClassificacaoDocumento.create([
								{descricao: 'Relaxamento de Prisão'}, 
								{descricao: 'Habeas Corpus'}, 
								{descricao: 'Liberdade Provisória'}, 
								{descricao: 'Revogação de Prisão Preventiva'}, 
								{descricao: 'Prisão Domiciliar'}, 
								{descricao: 'Pedido de Arbitramento de Fiança'}, 
								{descricao: 'Pedido de Restituição de Bens'}, 
								{descricao: 'Pedido de Juntada de Documentos'}, 
								])								