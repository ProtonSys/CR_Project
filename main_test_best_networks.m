clc;
clear;
close all;

% =========================================================================
% MAIN_TEST_BEST_NETWORKS
% =========================================================================
%
% Este script utiliza as 3 melhores redes neuronais guardadas para
% classificar os casos do dataset_TP_test.csv.
%
% São calculadas:
%   - precisão global
%   - precisão por classe
%   - matrizes de confusão
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026
%
% =========================================================================

addpath(genpath('src'));

% -------------------------------------------------------------------------
% Verificação da pasta de modelos
% -------------------------------------------------------------------------
if ~exist('models', 'dir')
    error('A pasta models não existe.');
end

% -------------------------------------------------------------------------
% Carregamento do dataset de treino
% -------------------------------------------------------------------------
T_train = readtable( ...
    fullfile('data', 'dataset_TP_tratado.csv'), ...
    'TextType', 'string');

validTrain = ~ismissing(T_train.class_cat) & ...
             strlength(strtrim(string(T_train.class_cat))) > 0;

T_train = T_train(validTrain,:);

% -------------------------------------------------------------------------
% Carregamento e pré-processamento do dataset de teste
% -------------------------------------------------------------------------
T_test = readtable( ...
    fullfile('data', 'dataset_TP_test.csv'), ...
    'TextType', 'string');

T_test = encodeCategoricalColumns(T_test);
T_test = fillMissingInputs(T_test);

validTest = ~ismissing(T_test.class_cat) & ...
            strlength(strtrim(string(T_test.class_cat))) > 0;

T_test = T_test(validTest,:);

% -------------------------------------------------------------------------
% Construção das matrizes para teste
% -------------------------------------------------------------------------
X_test = buildInputMatrix(T_test);

[Y_test, classNames] = buildBinaryTargets(T_test.class_cat);

results = table();

% -------------------------------------------------------------------------
% Avaliação das 3 melhores redes
% -------------------------------------------------------------------------
for i = 1:3

    S = load(fullfile('models', sprintf('net_top_%d.mat', i)));

    net = S.res.bestNet;

    Y_pred = net(X_test);

    predIdx = vec2ind(Y_pred);
    trueIdx = vec2ind(Y_test);

    % Precisão global
    globalAcc = mean(predIdx == trueIdx) * 100;

    % Precisão por classe
    classAcc = zeros(numel(classNames),1);

    for c = 1:numel(classNames)

        idx = (trueIdx == c);

        if any(idx)
            classAcc(c) = mean(predIdx(idx) == trueIdx(idx)) * 100;
        else
            classAcc(c) = NaN;
        end
    end

    % Construção da linha de resultados
    row = table( ...
        i, ...
        globalAcc, ...
        classAcc(1), ...
        classAcc(2), ...
        classAcc(3), ...
        'VariableNames', { ...
            'NetworkRank', ...
            'GlobalAcc', ...
            'Acc_Normal', ...
            'Acc_ElectricalFailure', ...
            'Acc_MechanicalFailure'});

    results = [results; row];

    % ---------------------------------------------------------------------
    % Guardar matriz de confusão
    % ---------------------------------------------------------------------
    fig = figure('Visible','off');

    plotconfusion(Y_test, Y_pred);

    saveas( ...
        fig, ...
        fullfile('models', sprintf('top_%d_test_plotconfusion.png', i)));

    close(fig);
end

% -------------------------------------------------------------------------
% Guarda dos resultados
% -------------------------------------------------------------------------
writetable( ...
    results, ...
    fullfile('results', 'NN_test_saved_networks_results.csv'));

disp(results);