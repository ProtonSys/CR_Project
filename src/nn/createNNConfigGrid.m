function configs = createNNConfigGrid()
% CREATENNCONFIGGRID Gera o conjunto de configurações das RN.
%
% Esta função cria diferentes combinações de:
%   - topologias
%   - funções de treino
%   - funções de ativação
%   - divisões treino/validação/teste
%   - épocas
%   - learning rates
%
% Saídas:
%   configs - vetor de estruturas com configurações
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026


    hiddenList = {
        [10]
        [20 10]
        [30 15]
    };

    trainFcns = {'traingd', 'trainbr', 'trainscg'};
    outputFcns = {'logsig', 'tansig', 'softmax'};
    divisions = [
        0.70 0.15 0.15
        0.80 0.10 0.10
        0.60 0.20 0.20
    ];

    epochsList = [200, 400];
    lrList = [0.01, 0.05];

    k = 1;
    configs = struct([]);

    for h = 1:numel(hiddenList)
        for t = 1:numel(trainFcns)
            for o = 1:numel(outputFcns)
                for d = 1:size(divisions,1)
                    for e = 1:numel(epochsList)
                        for lr = 1:numel(lrList)

                            configs(k).hiddenLayers = hiddenList{h};
                            configs(k).trainFcn     = trainFcns{t};
                            configs(k).outputFcn    = outputFcns{o};
                            configs(k).trainRatio   = divisions(d,1);
                            configs(k).valRatio     = divisions(d,2);
                            configs(k).testRatio    = divisions(d,3);
                            configs(k).epochs       = epochsList(e);
                            configs(k).lr           = lrList(lr);

                            k = k + 1;
                        end
                    end
                end
            end
        end
    end
end