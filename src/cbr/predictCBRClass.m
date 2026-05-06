function [predClass, topCases] = predictCBRClass(trainTable, newCase, weights, threshold, topN)
% PREDICTCBRCLASS Prevê a classe de um novo caso usando CBR.
%
% Esta função recupera os casos mais semelhantes ao novo caso e devolve
% a classe do caso mais semelhante.
%
% Entradas:
%   trainTable - base de casos
%   newCase    - novo caso
%   weights    - pesos dos atributos
%   threshold  - limiar mínimo de similaridade
%   topN       - número máximo de casos recuperados
%
% Saídas:
%   predClass - classe prevista
%   topCases  - casos mais semelhantes recuperados
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    if nargin < 5
        topN = 5;
    end

    inputVars = trainTable.Properties.VariableNames;

    inputVars(strcmp(inputVars, 'class_cat')) = [];

    knownMask = ~ismissing(trainTable.class_cat) & ...
                strlength(strtrim(string(trainTable.class_cat))) > 0;

    caseBase = trainTable(knownMask, :);

    ranges = buildRanges(caseBase, inputVars);

    topCases = retrieveCasesTopN( ...
        newCase, ...
        caseBase, ...
        inputVars, ...
        weights, ...
        ranges, ...
        threshold, ...
        topN);

    % Caso nenhum registo ultrapasse o limiar,
    % utiliza-se o caso mais semelhante independentemente do limiar
    if isempty(topCases)

        allCases = retrieveCasesTopN( ...
            newCase, ...
            caseBase, ...
            inputVars, ...
            weights, ...
            ranges, ...
            -inf, ...
            1);

        predClass = string(allCases.class_cat(1));
        topCases = allCases;

    else

        predClass = string(topCases.class_cat(1));

    end
end