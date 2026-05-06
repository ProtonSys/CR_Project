function retrieved = retrieveCasesTopN(newCase, caseBase, inputVars, weights, ranges, threshold, topN)
% RETRIEVECASESTOPN Recupera os casos mais semelhantes.
%
% Esta função calcula a similaridade entre um novo caso e todos os casos
% da base de casos, ordenando-os por similaridade decrescente.
%
% Entradas:
%   newCase  - novo caso
%   caseBase - base de casos
%   inputVars - atributos considerados
%   weights   - pesos dos atributos
%   ranges    - intervalos dos atributos
%   threshold - limiar mínimo de similaridade
%   topN      - número máximo de casos a devolver
%
% Saídas:
%   retrieved - tabela com os casos mais semelhantes
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    if nargin < 7
        topN = 5;
    end

    nCases = height(caseBase);
    sims = zeros(nCases,1);

    for i = 1:nCases

        sims(i) = globalSimilarityWithRanges( ...
            newCase, ...
            caseBase(i,:), ...
            inputVars, ...
            weights, ...
            ranges);
    end

    tempBase = caseBase;

    tempBase.similarity = sims;

    % Ordenação decrescente por similaridade
    tempBase = sortrows(tempBase, 'similarity', 'descend');

    % Aplicação do limiar
    retrieved = tempBase(tempBase.similarity >= threshold, :);

    % Limitação ao top-N
    if height(retrieved) > topN
        retrieved = retrieved(1:topN, :);
    end
end