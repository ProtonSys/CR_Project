function sim = localSimilarity(x, y)
% LOCALSIMILARITY Calcula a similaridade local entre dois valores.
%
% Esta função calcula a similaridade entre dois valores numéricos.
% O resultado é limitado ao intervalo [0,1].
%
% Entradas:
%   x - primeiro valor
%   y - segundo valor
%
% Saídas:
%   sim - similaridade local
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    % Caso algum dos valores esteja em falta, assume-se similaridade nula
    if isnan(x) || isnan(y)
        sim = 0;
        return;
    end

    % Se os valores forem iguais, a similaridade é máxima
    if x == y
        sim = 1;
        return;
    end

    % Escala simples da diferença relativa
    denom = max(abs([x y]));

    if denom == 0
        sim = 1;
    else
        sim = 1 - abs(x - y) / (denom + eps);
    end

    % Garantir que o resultado permanece entre 0 e 1
    sim = max(0, min(1, sim));
end