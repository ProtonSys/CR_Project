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

% -------------------------------------------------------------------------
% Seleção apenas dos casos com target conhecido
% -------------------------------------------------------------------------
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

% -------------------------------------------------------------------------
% Inicialização do cronómetro
% -------------------------------------------------------------------------
tic;

% -------------------------------------------------------------------------
% Inicialização da tabela de resultados
% -------------------------------------------------------------------------
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

    % -------------------------------------------------------------
    % Treino e avaliação da configuração atual
    % -------------------------------------------------------------
    res = trainEvaluateNNConfig( ...
        X, ...
        Y, ...
        cfg, ...
        10, ...
        false, ...
        fullfile('results', cfgName));

    % -------------------------------------------------------------
    % Construção da linha de resultados
    % -------------------------------------------------------------
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

    % -------------------------------------------------------------
    % Adiciona linha à tabela global
    % -------------------------------------------------------------
    resultsTable = [resultsTable; row];

end

% -------------------------------------------------------------------------
% Ordenação por precisão média de teste
% -------------------------------------------------------------------------
resultsTable = sortrows(resultsTable, 'MeanTest', 'descend');

% -------------------------------------------------------------------------
% Criar pasta de resultados caso não exista
% -------------------------------------------------------------------------
if ~exist('results', 'dir')
    mkdir('results');
end

% -------------------------------------------------------------------------
% Guardar resultados em CSV
% -------------------------------------------------------------------------
writetable( ...
    resultsTable, ...
    fullfile('results', 'NN_results_all.csv'));

% -------------------------------------------------------------------------
% Guardar resultados em Excel (.xls)
% -------------------------------------------------------------------------

try

    fid = fopen( ...
        fullfile('results', 'NN_results_all.xls'), ...
        'w');

    if fid == -1
        error('Não foi possível criar o ficheiro.');
    end

    % -------------------------------------------------------------
    % Cabeçalhos
    % -------------------------------------------------------------
    headers = resultsTable.Properties.VariableNames;

    for h = 1:length(headers)

        fprintf(fid, '%s', char(headers{h}));

        if h < length(headers)
            fprintf(fid, '\t');
        end

    end

    fprintf(fid, '\n');

    % -------------------------------------------------------------
    % Dados
    % -------------------------------------------------------------
    for i = 1:height(resultsTable)

        row = table2cell(resultsTable(i,:));

        for j = 1:length(row)

            value = row{j};

            if isnumeric(value)

                fprintf(fid, '%f', value);

            else

                fprintf(fid, '%s', char(string(value)));

            end

            if j < length(row)

                fprintf(fid, '\t');

            end

        end

        fprintf(fid, '\n');

    end

    fclose(fid);

    fprintf('\nFicheiro Excel (.xls) criado com sucesso.\n');

catch ME

    fprintf('\nErro ao criar ficheiro Excel:\n');

    disp(getReport(ME, 'extended'));

end


% -------------------------------------------------------------------------
% Mostrar melhores configurações
% -------------------------------------------------------------------------
disp(resultsTable(1:min(10,height(resultsTable)), :));

% -------------------------------------------------------------------------
% Mostrar tempo total de execução
% -------------------------------------------------------------------------
fprintf('\nTempo total: %.2f minutos\n', toc/60);

% -------------------------------------------------------------------------
% Gráfico comparativo das accuracies
% -------------------------------------------------------------------------
figure;

bar(resultsTable.MeanTest);

xticklabels(string(resultsTable.ConfigName));

xtickangle(45);

xlabel('Configurações de Rede Neural');

ylabel('Precisão Média de Teste (%)');

title('Comparação das Precisões Médias de Teste');

grid on;

drawnow;

saveas(gcf, ...
    fullfile('results', 'accuracy_comparison.png'));

close(gcf);

% -------------------------------------------------------------------------
% Guardar gráfico
% -------------------------------------------------------------------------
saveas(gcf, ...
    fullfile('results', 'accuracy_comparison.png'));

close(gcf);

fprintf('\nGráfico comparativo guardado com sucesso.\n');