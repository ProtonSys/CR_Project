function T_out = applyTrainMinMax(T_train, T_test)
% APPLYTRAINMINMAX Aplica normalização do treino ao conjunto de teste.
%
% Esta função utiliza os valores mínimo e máximo obtidos no dataset de
% treino para normalizar os atributos do dataset de teste.
%
% Esta abordagem evita data leakage e garante consistência entre:
%   - treino
%   - validação
%   - teste
%
% Entradas:
%   T_train - dataset de treino
%   T_test  - dataset de teste
%
% Saídas:
%   T_out - dataset de teste normalizado
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    % ---------------------------------------------------------------------
    % Inicialização da tabela de saída
    % ---------------------------------------------------------------------
    T_out = T_test;

    vars = T_train.Properties.VariableNames;

    % ---------------------------------------------------------------------
    % Percorrer todos os atributos
    % ---------------------------------------------------------------------
    for i = 1:numel(vars)

        varName = vars{i};

        % Ignorar coluna target
        if strcmp(varName, 'class_cat')
            continue;
        end

        % Apenas atributos numéricos
        if isnumeric(T_train.(varName)) && ...
           isnumeric(T_test.(varName))

            minVal = min(T_train.(varName));
            maxVal = max(T_train.(varName));

            % Evitar divisão por zero
            if maxVal > minVal

                % ---------------------------------------------------------
                % Aplicação da normalização Min-Max
                % utilizando apenas informação do treino
                % ---------------------------------------------------------
                T_out.(varName) = ...
                    (T_test.(varName) - minVal) / ...
                    (maxVal - minVal);

            else

                T_out.(varName) = T_test.(varName);

            end
        end
    end
end