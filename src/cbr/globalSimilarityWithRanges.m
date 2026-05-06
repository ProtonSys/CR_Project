function sim = globalSimilarityWithRanges(caseA, caseB, inputVars, weights, ranges)
% GLOBALSIMILARITYWITHRANGES Calcula similaridade global ponderada.
%
% Esta função combina as similaridades locais de todos os atributos
% utilizando uma média ponderada pelos pesos definidos.
%
% Entradas:
%   caseA     - primeiro caso
%   caseB     - segundo caso
%   inputVars - atributos considerados
%   weights   - pesos dos atributos
%   ranges    - intervalos dos atributos
%
% Saídas:
%   sim - similaridade global
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    localSims = zeros(1, numel(inputVars));

    for j = 1:numel(inputVars)

        varName = inputVars{j};

        x = caseA.(varName);
        y = caseB.(varName);

        localSims(j) = localSimilarityWithType(x, y, ranges.(varName));
    end

    sim = sum(weights .* localSims) / sum(weights);
end