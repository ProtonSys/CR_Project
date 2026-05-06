function T = encodeCategoricalColumns(T)
% ENCODECATEGORICALCOLUMNS Converte atributos categóricos em valores numéricos.
%
% Esta função converte os atributos categóricos do dataset em valores
% numéricos, preservando a relação semântica entre os valores sempre que
% essa relação existe.
%
% Entradas:
%   T - tabela com o dataset original
%
% Saídas:
%   T - tabela com os atributos categóricos codificados numericamente
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    % maintenance_level possui uma ordem natural: Low < Medium < High
    if ismember('maintenance_level', T.Properties.VariableNames)
        T.maintenance_level = encodeOrdinal(T.maintenance_level, ...
            ["Low","Medium","High"], [0, 0.5, 1]);
    end

    % operating_mode também possui relação ordinal: Idle < Normal < Overload
    if ismember('operating_mode', T.Properties.VariableNames)
        T.operating_mode = encodeOrdinal(T.operating_mode, ...
            ["Idle","Normal","Overload"], [0, 0.5, 1]);
    end

    % cooling_type é binário, sem ordem natural
    if ismember('cooling_type', T.Properties.VariableNames)
        T.cooling_type = encodeOrdinal(T.cooling_type, ...
            ["Air","Oil"], [0, 1]);
    end

    % sensor_status representa funcionamento normal ou aviso
    if ismember('sensor_status', T.Properties.VariableNames)
        T.sensor_status = encodeOrdinal(T.sensor_status, ...
            ["OK","Warning"], [0, 1]);
    end
end