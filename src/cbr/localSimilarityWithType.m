function sim = localSimilarityWithType(x, y, rangeVal)
% LOCALSIMILARITYWITHTYPE Calcula similaridade local normalizada.
%
% Esta função calcula a similaridade local entre dois valores,
% normalizando a diferença através do intervalo do atributo.
%
% Entradas:
%   x        - primeiro valor
%   y        - segundo valor
%   rangeVal - intervalo do atributo
%
% Saídas:
%   sim - similaridade local no intervalo [0,1]
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    if isnan(x) || isnan(y)
        sim = 0;
        return;
    end

    if x == y
        sim = 1;
        return;
    end

    if rangeVal == 0
        sim = 1;
        return;
    end

    sim = 1 - abs(x - y) / (rangeVal + eps);

    sim = max(0, min(1, sim));
end