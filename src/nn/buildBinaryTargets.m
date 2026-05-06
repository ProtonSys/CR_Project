function [Y, classNames] = buildBinaryTargets(classCol)
% BUILDBINARYTARGETS Constrói o target binário para classificação multiclasse.
%
% Esta função converte a coluna de classes numa matriz binária, onde cada
% linha corresponde a uma classe e cada coluna a uma amostra.
%
% Entradas:
%   classCol - coluna com as classes do dataset
%
% Saídas:
%   Y          - matriz binária do target
%   classNames - nomes das classes
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    classNames = ["Normal", "ElectricalFailure", "MechanicalFailure"];

    nClasses = numel(classNames);
    nSamples = numel(classCol);
    Y = zeros(nClasses, nSamples);

    for i = 1:nSamples
        idx = find(strcmp(string(classCol(i)), classNames), 1);

        if ~isempty(idx)
            Y(idx, i) = 1;
        end
    end
end