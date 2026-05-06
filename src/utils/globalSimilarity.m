function sim = globalSimilarity(caseA, caseB, inputVars, weights)
% GLOBALSIMILARITY Calcula a similaridade global entre dois casos.
%
% A similaridade global é obtida através da média ponderada das
% similaridades locais de cada atributo.
%
% Entradas:
%   caseA     - primeiro caso
%   caseB     - segundo caso
%   inputVars - nomes dos atributos de entrada
%   weights   - pesos dos atributos
%
% Saídas:
%   sim - valor de similaridade global no intervalo [0,1]
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

        % Cálculo da similaridade local do atributo atual
        localSims(j) = localSimilarity(x, y);
    end

    % Média ponderada das similaridades locais
    sim = sum(weights .* localSims) / sum(weights);
end