function results = runCBRBatchTest(trainTable, testTable, weights, threshold, topN)
% RUNCBRBATCHTEST Avalia o sistema CBR num conjunto de teste.
%
% Para cada caso do conjunto de teste, esta função determina a classe
% prevista pelo CBR e compara-a com a classe real. No final devolve a
% precisão top-1 do sistema.
%
% Entradas:
%   trainTable - tabela de treino / base de casos
%   testTable  - tabela de teste
%   weights    - vetor de pesos dos atributos
%   threshold  - limiar mínimo de similaridade
%   topN       - número máximo de casos semelhantes a considerar
%
% Saídas:
%   results - estrutura com resultados da avaliação
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    if nargin < 5
        topN = 5;
    end

    % Garantir que apenas são usados casos de teste com classe conhecida
    validTestMask = ~ismissing(testTable.class_cat) & strlength(strtrim(string(testTable.class_cat))) > 0;
    testTable = testTable(validTestMask, :);

    n = height(testTable);
    yTrue = strings(n,1);
    yPred = strings(n,1);
    bestSim = zeros(n,1);

    for i = 1:n
        newCase = testTable(i,:);

        % Obter a previsão da classe pelo CBR
        [predClass, topCases] = predictCBRClass(trainTable, newCase, weights, threshold, topN);

        yTrue(i) = string(testTable.class_cat(i));
        yPred(i) = string(predClass);

        if isempty(topCases)
            bestSim(i) = NaN;
        else
            bestSim(i) = topCases.similarity(1);
        end
    end

    % Cálculo da percentagem de acerto top-1
    acc = mean(yPred == yTrue) * 100;

    results = struct();
    results.nCases = n;
    results.yTrue = yTrue;
    results.yPred = yPred;
    results.bestSimilarity = bestSim;
    results.accuracyTop1 = acc;

    fprintf('Precisão top-1 CBR: %.2f%%\n', acc);
end