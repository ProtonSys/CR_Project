function saveTop3Networks()
% SAVETOP3NETWORKS Re-treina e guarda as 3 melhores redes neuronais.
%
% Esta função lê o ficheiro com os resultados globais das experiências,
% seleciona as 3 configurações com melhor precisão média no teste,
% volta a treiná-las e guarda os modelos em disco.
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    T = readtable(fullfile('data', 'dataset_TP_tratado.csv'), 'TextType', 'string');

    validMask = ~ismissing(T.class_cat) & strlength(strtrim(string(T.class_cat))) > 0;
    T = T(validMask,:);

    X = buildInputMatrix(T);
    [Y, classNames] = buildBinaryTargets(T.class_cat);

    R = readtable(fullfile('results', 'NN_results_all.csv'), 'TextType', 'string');
    R = sortrows(R, 'MeanTest', 'descend');

    topK = min(3, height(R));

    if ~exist('models', 'dir')
        mkdir('models');
    end

    for i = 1:topK
        % Reconstrução da configuração a partir da tabela de resultados
        cfg = reconstructConfigFromRow(R(i,:));

        % Novo treino da configuração selecionada
        res = trainEvaluateNNConfig(X, Y, cfg, 10, true, fullfile('models', sprintf('top%d', i)));

        % Guarda da rede e metadados associados
        save(fullfile('models', sprintf('net_top_%d.mat', i)), ...
            'cfg', 'res', 'classNames');
    end
end