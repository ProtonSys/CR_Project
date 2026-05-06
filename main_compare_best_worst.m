clc;
clear;
close all;

% =========================================================================
% MAIN_COMPARE_BEST_WORST
% =========================================================================
%
% Este script compara as 3 melhores e as 3 piores configurações de redes
% neuronais utilizando:
%   - dataset normalizado
%   - dataset não normalizado
%
% O objetivo é analisar o impacto da normalização no desempenho.
%
% Autor: Teu Nome: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026
%
% =========================================================================

addpath(genpath('src'));

% -------------------------------------------------------------------------
% Leitura da tabela de resultados globais
% -------------------------------------------------------------------------
R = readtable( ...
    fullfile('results', 'NN_results_all.csv'), ...
    'TextType', 'string');

R = sortrows(R, 'MeanTest', 'descend');

% Seleção das melhores e piores configurações
top3 = R(1:3,:);
bot3 = R(end-2:end,:);

% -------------------------------------------------------------------------
% Carregamento dos datasets
% -------------------------------------------------------------------------
T_raw = readtable( ...
    fullfile('data', 'dataset_TP_tratado.csv'), ...
    'TextType', 'string');

T_norm = readtable( ...
    fullfile('data', 'dataset_TP_tratado_normalizado.csv'), ...
    'TextType', 'string');

validRaw = ~ismissing(T_raw.class_cat) & ...
           strlength(strtrim(string(T_raw.class_cat))) > 0;

validNorm = ~ismissing(T_norm.class_cat) & ...
            strlength(strtrim(string(T_norm.class_cat))) > 0;

T_raw = T_raw(validRaw,:);
T_norm = T_norm(validNorm,:);

% -------------------------------------------------------------------------
% Construção das matrizes de entrada
% -------------------------------------------------------------------------
X_raw = buildInputMatrix(T_raw);
[Y_raw, ~] = buildBinaryTargets(T_raw.class_cat);

X_norm = buildInputMatrix(T_norm);
[Y_norm, ~] = buildBinaryTargets(T_norm.class_cat);

selected = [top3; bot3];

summary = table();

% -------------------------------------------------------------------------
% Comparação raw vs normalized
% -------------------------------------------------------------------------
for i = 1:height(selected)

    cfg = reconstructConfigFromRow(selected(i,:));

    cfgName = selected.ConfigName(i);

    fprintf('\nComparação raw vs normalized: %s\n', cfgName);

    resRaw = trainEvaluateNNConfig( ...
        X_raw, ...
        Y_raw, ...
        cfg, ...
        10, ...
        false, ...
        'raw');

    resNorm = trainEvaluateNNConfig( ...
        X_norm, ...
        Y_norm, ...
        cfg, ...
        10, ...
        false, ...
        'norm');

    row = table( ...
        string(cfgName), ...
        resRaw.meanTest, ...
        resNorm.meanTest, ...
        resNorm.meanTest - resRaw.meanTest, ...
        'VariableNames', { ...
            'ConfigName', ...
            'MeanTest_Raw', ...
            'MeanTest_Norm', ...
            'DiffNormMinusRaw'});

    summary = [summary; row];
end

% -------------------------------------------------------------------------
% Guarda da tabela resumo
% -------------------------------------------------------------------------
writetable( ...
    summary, ...
    fullfile('results', 'NN_best_worst_norm_vs_raw.csv'));

disp(summary);