function ranges = buildRanges(T, inputVars)
% BUILDRANGES Calcula os intervalos dos atributos numéricos.
%
% Esta função calcula o intervalo (máximo - mínimo) de cada atributo,
% permitindo normalizar diferenças no cálculo da similaridade local.
%
% Entradas:
%   T         - tabela com os dados
%   inputVars - nomes dos atributos de entrada
%
% Saídas:
%   ranges - estrutura com os intervalos de cada atributo
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    ranges = struct();

    for i = 1:numel(inputVars)

        varName = inputVars{i};
        col = T.(varName);

        if isnumeric(col)

            validCol = col(~isnan(col));

            if isempty(validCol)
                ranges.(varName) = 1;
            else
                ranges.(varName) = max(validCol) - min(validCol);
            end

        else
            ranges.(varName) = 1;
        end
    end
end