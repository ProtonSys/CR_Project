function net = loadOrTrainTemperatureNN(T, modelFile)
% LOADORTRAINTEMPERATURENN Carrega ou treina a rede neuronal do Reuse.
%
% Esta função verifica se já existe uma rede neuronal guardada em disco.
%
% Se existir:
%   - a rede é carregada
%
% Caso contrário:
%   - a rede é treinada
%   - a rede é guardada automaticamente
%
% Esta abordagem evita treinar a rede repetidamente em cada execução,
% reduzindo significativamente o tempo de processamento.
%
% Entradas:
%   T         - tabela com o dataset
%   modelFile - ficheiro da rede neuronal
%
% Saídas:
%   net - rede neuronal carregada ou treinada
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    % ---------------------------------------------------------------------
    % Nome default do ficheiro da rede
    % ---------------------------------------------------------------------
    if nargin < 2
        modelFile = 'temperature_reuse_net.mat';
    end

    % ---------------------------------------------------------------------
    % Verificação da existência da rede em disco
    % ---------------------------------------------------------------------
    if isfile(modelFile)

        % Carregamento da rede previamente treinada
        S = load(modelFile, 'net');

        net = S.net;

        fprintf( ...
            'Rede neuronal carregada de: %s\n', ...
            modelFile);

    else

        fprintf( ...
            'Rede não encontrada. A iniciar treino...\n');

        % Treino e guarda automática da rede
        net = trainAndSaveTemperatureNN(T, modelFile);

    end
end