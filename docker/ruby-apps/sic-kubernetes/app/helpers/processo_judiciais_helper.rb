module ProcessoJudiciaisHelper
    VISTA_DOS_ALTOS_OK = '1'

    def get_locais_acessiveis
        lotacoes = LotacaoDefensor.get_lotacao_defensor(get_cpf).map{ |l| l.descricao_local }
        locais_acessiveis = Array.new
        locais_inacessiveis = Array.new
        @processo_judicial.local_atuacao_processo.each do |local|
            if ([local.lotacao_defensor.descricao_local] & lotacoes).any?
                locais_acessiveis << local
            else
                locais_inacessiveis << local
            end
        end
        return {locais_acessiveis: locais_acessiveis, locais_inacessiveis: locais_inacessiveis}
    end

    def numeric?(string)
        return true if string =~ /\A\d+\Z/
        true if Float(string) rescue false
    end

end
