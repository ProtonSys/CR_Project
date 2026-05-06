function T = fillMissingInputs(T)
% FILLMISSINGINPUTS Preenche valores em falta nos atributos de entrada.
%
% Esta função percorre todas as colunas do dataset, exceto a coluna target,
% e preenche os valores em falta. Para atributos numéricos é utilizada a
% mediana. Para atributos não numéricos é utilizada a moda.
%
% Entradas:
%   T - tabela com o dataset
%
% Saídas:
%   T - tabela com os missing values dos inputs preenchidos
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    vars = T.Properties.VariableNames;

    for i = 1:numel(vars)
        varName = vars{i};

        % A coluna target não é tratada aqui
        if strcmp(varName, 'class_cat')
            continue;
        end

        col = T.(varName);

        % Tratamento de colunas numéricas
        if isnumeric(col)
            valid = col(~isnan(col));

            if ~isempty(valid)
                % A mediana é usada por ser robusta a valores extremos
                medVal = median(valid);
                col(isnan(col)) = medVal;
                T.(varName) = col;
            end
        else
            % Tratamento de colunas categóricas/textuais
            mask = ismissing(col);

            if any(~mask)
                mostFreq = mode(categorical(col(~mask)));
                col(mask) = string(mostFreq);
                T.(varName) = col;
            end
        end
    end
end