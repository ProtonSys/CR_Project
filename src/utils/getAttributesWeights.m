function weights = getAttributesWeights()
% GETATTRIBUTEWEIGHTS Devolve os pesos dos atributos utilizados no CBR.
%
% Esta função define os pesos associados a cada atributo do dataset para o
% cálculo da similaridade global no sistema de raciocínio baseado em casos.
%
% Os pesos foram definidos com base na relevância esperada de cada atributo
% no diagnóstico de falhas industriais.
%
% Atributos relacionados com:
%   - vibração
%   - corrente
%   - tensão
%   - torque
%
% recebem maior peso, pois tendem a ser mais importantes na distinção
% entre falhas mecânicas e falhas elétricas.
%
% Ordem esperada dos atributos:
%
%   1  - temperature
%   2  - vibration
%   3  - rotation_speed
%   4  - voltage
%   5  - current
%   6  - pressure
%   7  - noise_level
%   8  - efficiency
%   9  - load_val
%   10 - torque
%   11 - maintenance_level
%   12 - operating_mode
%   13 - cooling_type
%   14 - sensor_status
%
% Saídas:
%   weights - vetor de pesos dos atributos
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    % ---------------------------------------------------------------------
    % Definição dos pesos dos atributos
    % ---------------------------------------------------------------------
    weights = [ ...
        0.10, ... % temperature
        0.14, ... % vibration
        0.09, ... % rotation_speed
        0.12, ... % voltage
        0.12, ... % current
        0.08, ... % pressure
        0.08, ... % noise_level
        0.06, ... % efficiency
        0.05, ... % load_val
        0.10, ... % torque
        0.03, ... % maintenance_level
        0.02, ... % operating_mode
        0.005, ...% cooling_type
        0.005  ...% sensor_status
    ];

    % ---------------------------------------------------------------------
    % Validação simples da soma dos pesos
    % ---------------------------------------------------------------------
    % Esta verificação ajuda a garantir coerência na definição dos pesos.
    totalWeight = sum(weights);

    fprintf('Soma total dos pesos: %.4f\n', totalWeight);
end