function colOut = encodeOrdinal(colIn, labels, values)
% ENCODEORDINAL Converte atributos categóricos ordinais em valores numéricos.
%
% Esta função converte uma coluna categórica para representação numérica,
% preservando a relação ordinal entre os diferentes valores.
%
% Exemplos:
%   Low < Medium < High
%   Idle < Normal < Overload
%
% Entradas:
%   colIn  - coluna categórica original
%   labels - labels/textos esperados
%   values - valores numéricos associados a cada label
%
% Saídas:
%   colOut - coluna convertida para valores numéricos
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    % ---------------------------------------------------------------------
    % Inicialização do vetor de saída
    % ---------------------------------------------------------------------
    n = numel(colIn);

    colOut = nan(n,1);

    % ---------------------------------------------------------------------
    % Conversão elemento a elemento
    % ---------------------------------------------------------------------
    for i = 1:n

        % Verifica se o valor está em falta
        if ismissing(colIn(i)) || ...
           strlength(strtrim(string(colIn(i)))) == 0

            colOut(i) = NaN;

        else

            % Procura o índice correspondente ao label atual
            idx = find( ...
                strcmpi( ...
                    strtrim(string(colIn(i))), ...
                    labels), ...
                1);

            % Caso exista correspondência, utiliza o valor definido
            if ~isempty(idx)

                colOut(i) = values(idx);

            else

                % Caso não exista correspondência conhecida
                colOut(i) = NaN;

            end
        end
    end
end