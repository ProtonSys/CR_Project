clc;
clear;
close all;

% =========================================================================
% MAIN_CBR_EXPERIMENTS
% =========================================================================
%
% Este script executa as experiências do sistema de CBR.
%
% São avaliadas diferentes configurações:
%   - diferentes conjuntos de pesos
%   - dataset normalizado vs não normalizado
%
% O desempenho é medido através da percentagem de acerto top-1
% utilizando o ficheiro dataset_TP_test.csv.
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026
%
% =========================================================================

% Adicionar subpastas ao path
addpath(genpath('src'));

% -------------------------------------------------------------------------
% Carregamento dos datasets
% -------------------------------------------------------------------------
T_train_raw  = readtable( ...
    fullfile('data', 'dataset_TP_tratado.csv'), ...
    'TextType', 'string');

T_train_norm = readtable( ...
    fullfile('data', 'dataset_TP_tratado_normalizado.csv'), ...
    'TextType', 'string');

T_test = readtable( ...
    fullfile('data', 'dataset_TP_test.csv'), ...
    'TextType', 'string');

% -------------------------------------------------------------------------
% Pré-processamento do dataset de teste
% -------------------------------------------------------------------------
T_test = encodeCategoricalColumns(T_test);
T_test = fillMissingInputs(T_test);

% Aplicação da normalização do treino ao conjunto de teste
T_test_norm = applyTrainMinMax(T_train_raw, T_test);

% -------------------------------------------------------------------------
% Treino da rede neuronal usada na etapa Reuse do CBR
% -------------------------------------------------------------------------
if ~exist('models', 'dir')
    mkdir('models');
end

modelFile = fullfile('models', 'temperature_reuse_net.mat');

trainAndSaveTemperatureNN(T_train_raw, modelFile);

% -------------------------------------------------------------------------
% Definição dos conjuntos de pesos
% -------------------------------------------------------------------------
weightsA = getAttributesWeights();

% Pesos uniformes
weightsB = ones(1,14) / 14;

% Pesos alternativos com maior relevância em sensores críticos
weightsC = [ ...
    0.08 0.18 0.10 0.14 0.14 ...
    0.06 0.08 0.04 0.03 0.10 ...
    0.02 0.02 0.005 0.005];

% -------------------------------------------------------------------------
% Parâmetros do CBR
% -------------------------------------------------------------------------
threshold = 0.80;
topN = 5;

% -------------------------------------------------------------------------
% Configurações experimentais
% -------------------------------------------------------------------------
configs = {
    'NaoNormalizado_PesosA', T_train_raw,  T_test,      weightsA;
    'NaoNormalizado_PesosB', T_train_raw,  T_test,      weightsB;
    'NaoNormalizado_PesosC', T_train_raw,  T_test,      weightsC;

    'Normalizado_PesosA',    T_train_norm, T_test_norm, weightsA;
    'Normalizado_PesosB',    T_train_norm, T_test_norm, weightsB;
    'Normalizado_PesosC',    T_train_norm, T_test_norm, weightsC;
};

summaryNames = strings(size(configs,1),1);
summaryAcc   = zeros(size(configs,1),1);

% -------------------------------------------------------------------------
% Execução das experiências
% -------------------------------------------------------------------------
for i = 1:size(configs,1)

    cfgName = configs{i,1};
    trainTb = configs{i,2};
    testTb  = configs{i,3};
    w       = configs{i,4};

    fprintf('\n========================================\n');
    fprintf('Configuração CBR: %s\n', cfgName);
    fprintf('========================================\n');

    res = runCBRBatchTest( ...
        trainTb, ...
        testTb, ...
        w, ...
        threshold, ...
        topN);

    summaryNames(i) = string(cfgName);
    summaryAcc(i) = res.accuracyTop1;
end

% -------------------------------------------------------------------------
% Construção da tabela resumo
% -------------------------------------------------------------------------
T_summary = table( ...
    summaryNames, ...
    summaryAcc, ...
    'VariableNames', {'Configuracao','PrecisaoTop1'});

% -------------------------------------------------------------------------
% Guarda dos resultados
% -------------------------------------------------------------------------
if ~exist('results', 'dir')
    mkdir('results');
end

disp(T_summary);

writetable( ...
    T_summary, ...
    fullfile('results', 'CBR_results_summary.csv'));