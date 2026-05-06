function result = trainEvaluateNNConfig(X, T, cfg, nRuns, saveConfusion, prefixName)
% TRAINEVALUATENNCONFIG Treina e avalia uma configuração de rede neuronal.
%
% Esta função executa várias repetições da mesma configuração de rede
% neuronal, regista a precisão global e a precisão no conjunto de teste,
% e devolve as médias e desvios-padrão obtidos.
%
% Entradas:
%   X             - matriz de entrada
%   T             - matriz target binária
%   cfg           - estrutura com a configuração da rede
%   nRuns         - número de repetições
%   saveConfusion - indica se deve guardar plotconfusion
%   prefixName    - prefixo para o nome do ficheiro de saída
%
% Saídas:
%   result - estrutura com estatísticas e melhor rede encontrada
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    if nargin < 4
        nRuns = 10;
    end
    if nargin < 5
        saveConfusion = false;
    end
    if nargin < 6
        prefixName = 'exp';
    end

    accGlobal = zeros(nRuns,1);
    accTest = zeros(nRuns,1);

    bestNet = [];
    bestTr = [];
    bestTestAcc = -inf;

    for r = 1:nRuns
        % -------------------------------------------------------------
        % Criação da rede para a configuração atual
        % -------------------------------------------------------------
        net = patternnet(cfg.hiddenLayers, cfg.trainFcn);

        % Nas camadas escondidas usa-se tansig
        for i = 1:numel(net.layers)-1
            net.layers{i}.transferFcn = 'tansig';
        end

        % Na camada de saída usa-se a função definida na configuração
        try
            net.layers{end}.transferFcn = cfg.outputFcn;
        catch
            net.layers{end}.transferFcn = 'logsig';
        end

        % Divisão treino/validação/teste
        net.divideParam.trainRatio = cfg.trainRatio;
        net.divideParam.valRatio   = cfg.valRatio;
        net.divideParam.testRatio  = cfg.testRatio;

        % Parâmetros de treino
        net.trainParam.epochs = cfg.epochs;

        if strcmp(cfg.trainFcn, 'traingd')
            net.trainParam.lr = cfg.lr;
        end

        net.trainParam.showWindow = false;

        % -------------------------------------------------------------
        % Treino da rede
        % -------------------------------------------------------------
        [net, tr] = train(net, X, T);

        % Saídas previstas
        Y = net(X);

        % Precisão global
        pred = vec2ind(Y);
        real = vec2ind(T);
        accGlobal(r) = mean(pred == real) * 100;

        % Precisão no subconjunto de teste
        testInd = tr.testInd;
        predTest = vec2ind(Y(:, testInd));
        realTest = vec2ind(T(:, testInd));
        accTest(r) = mean(predTest == realTest) * 100;

        % Guardar a melhor rede encontrada
        if accTest(r) > bestTestAcc
            bestTestAcc = accTest(r);
            bestNet = net;
            bestTr = tr;
        end
    end

    % Construção da estrutura final de resultados
    result = struct();
    result.cfg = cfg;
    result.meanGlobal = mean(accGlobal);
    result.stdGlobal = std(accGlobal);
    result.meanTest = mean(accTest);
    result.stdTest = std(accTest);
    result.bestNet = bestNet;
    result.bestTr = bestTr;
    result.allGlobal = accGlobal;
    result.allTest = accTest;

    % Guardar matriz de confusão da melhor rede, se pedido
    if saveConfusion && ~isempty(bestNet)
        Ybest = bestNet(X);
        fig = figure('Visible','off');
        plotconfusion(T, Ybest);
        saveas(fig, sprintf('%s_plotconfusion.png', prefixName));
        close(fig);
    end
end