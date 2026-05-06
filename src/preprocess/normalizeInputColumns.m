function T_norm = normalizeInputColumns(T)
% NORMALIZEINPUTCOLUMNS Normaliza os atributos numéricos do dataset.
%
% Esta função aplica normalização Min-Max aos atributos numéricos,
% convertendo os valores para o intervalo [0,1].
%
% A coluna target não é normalizada.
%
% Entradas:
%   T - tabela original
%
% Saídas:
%   T_norm - tabela com os atributos normalizados
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    % ---------------------------------------------------------------------
    % Inicialização da tabela de saída
    % ---------------------------------------------------------------------
    T_norm = T;

    vars = T.Properties.VariableNames;

    % ---------------------------------------------------------------------
    % Percorrer todas as colunas
    % ---------------------------------------------------------------------
    for i = 1:numel(vars)

        varName = vars{i};

        % Ignorar a coluna target
        if strcmp(varName, 'class_cat')
            continue;
        end

        col = T.(varName);

        % Apenas atributos numéricos são normalizados
        if isnumeric(col)

            minVal = min(col);
            maxVal = max(col);

            % Evitar divisão por zero
            if maxVal > minVal

                % ---------------------------------------------------------
                % Normalização Min-Max
                % ---------------------------------------------------------
                T_norm.(varName) = ...
                    (col - minVal) / (maxVal - minVal);

            else

                T_norm.(varName) = col;

            end
        end
    end
end