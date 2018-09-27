def tamanho_arquivo(arquivo)
	begin
		number_to_human_size(File.size(arquivo))
	rescue
		"Arquivo Não Encontrado"
	end
end

def debug
	raise "lol"
end
