function net = trainAndSaveTemperatureNN(T, modelFile)
% TRAINANDSAVETEMPERATURENN Treina a RN usada na etapa Reuse.
%
% Esta rede neuronal feedforward é utilizada para prever um valor ajustado
% de temperature com base nos atributos vibration, rotation_speed e voltage.
%
% Entradas:
%   T         - tabela com o dataset
%   modelFile - nome do ficheiro onde a rede será guardada
%
% Saídas:
%   net - rede neuronal treinada
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    if nargin < 2
        modelFile = 'temperature_reuse_net.mat';
    end

    requiredVars = {'vibration','rotation_speed','voltage','temperature'};

    for i = 1:numel(requiredVars)

        if ~ismember(requiredVars{i}, T.Properties.VariableNames)

            error('Falta a variável %s.', requiredVars{i});

        end
    end

    % Apenas são usados registos válidos
    validMask = ~isnan(T.vibration) & ...
                ~isnan(T.rotation_speed) & ...
                ~isnan(T.voltage) & ...
                ~isnan(T.temperature);

    X = [ ...
        T.vibration(validMask), ...
        T.rotation_speed(validMask), ...
        T.voltage(validMask)]';

    Y = T.temperature(validMask)';

    % Rede feedforward para regressão
    net = fitnet([10 5], 'trainlm');

    net.divideParam.trainRatio = 0.70;
    net.divideParam.valRatio   = 0.15;
    net.divideParam.testRatio  = 0.15;

    net.trainParam.showWindow = false;

    % Treino da rede
    net = train(net, X, Y);

    % Guarda da rede treinada
    save(modelFile, 'net');
end