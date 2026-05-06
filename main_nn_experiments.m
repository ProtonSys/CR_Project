clc;
clear;
close all;

% =========================================================================
% MAIN_NN_EXPERIMENTS
% =========================================================================
%
% Este script executa as experiências das redes neuronais feedforward.
%
% São testadas múltiplas configurações variando:
%   - topologia
%   - algoritmo de treino
%   - função de ativação
%   - divisão treino/validação/teste
%   - número de épocas
%   - learning rate
%
% Para cada configuração são realizadas 10 repetições.
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026
%
% =========================================================================

addpath(genpath('src'));

% -------------------------------------------------------------------------
% Carregamento do dataset tratado
% -------------------------------------------------------------------------
T = readtable( ...
    fullfile('data', 'dataset_TP_tratado.csv'), ...
    'TextType', 'string');

% Apenas casos com classe conhecida
validMask = ~ismissing(T.class_cat) & ...
            strlength(strtrim(string(T.class_cat))) > 0;

T = T(validMask,:);

% -------------------------------------------------------------------------
% Construção da matriz de entrada e target binário
% -------------------------------------------------------------------------
X = buildInputMatrix(T);

[Y, ~] = buildBinaryTargets(T.class_cat);

% -------------------------------------------------------------------------
% Geração das configurações experimentais
% -------------------------------------------------------------------------
configs = createNNConfigGrid();

tic;

resultsTable = table();

% -------------------------------------------------------------------------
% Execução das experiências
% -------------------------------------------------------------------------
for i = 1:numel(configs)

    cfg = configs(i);

    cfgName = configToString(cfg);

    fprintf('\n========================================\n');
    fprintf('Experiência %d/%d\n', i, numel(configs));
    fprintf('%s\n', cfgName);
    fprintf('========================================\n');

    res = trainEvaluateNNConfig( ...
        X, ...
        Y, ...
        cfg, ...
        10, ...
        false, ...
        cfgName);

    % Construção da linha de resultados
    row = table( ...
        string(cfgName), ...
        string(mat2str(cfg.hiddenLayers)), ...
        string(cfg.trainFcn), ...
        string(cfg.outputFcn), ...
        cfg.trainRatio, ...
        cfg.valRatio, ...
        cfg.testRatio, ...
        cfg.epochs, ...
        cfg.lr, ...
        res.meanGlobal, ...
        res.stdGlobal, ...
        res.meanTest, ...
        res.stdTest, ...
        'VariableNames', { ...
            'ConfigName', ...
            'HiddenLayers', ...
            'TrainFcn', ...
            'OutputFcn', ...
            'TrainRatio', ...
            'ValRatio', ...
            'TestRatio', ...
            'Epochs', ...
            'LR', ...
            'MeanGlobal', ...
            'StdGlobal', ...
            'MeanTest', ...
            'StdTest'});

    resultsTable = [resultsTable; row];
end

% -------------------------------------------------------------------------
% Ordenação por precisão média de teste
% -------------------------------------------------------------------------
resultsTable = sortrows(resultsTable, 'MeanTest', 'descend');

% -------------------------------------------------------------------------
% Guarda dos resultados
% -------------------------------------------------------------------------
if ~exist('results', 'dir')
    mkdir('results');
end

writetable( ...
    resultsTable, ...
    fullfile('results', 'NN_results_all.csv'));

% Mostrar melhores configurações
disp(resultsTable(1:min(10,height(resultsTable)), :));

% Mostra tempo decorrido
fprintf('\nTempo total: %.2f minutos\n', toc/60);