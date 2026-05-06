function T = fillMissingTargetCBR(T, weights)
% FILLMISSINGTARGETCBR Preenche valores em falta no target usando CBR.
%
% Para cada registo cujo target está em falta, esta função procura o caso
% conhecido mais semelhante e copia a respetiva classe.
%
% Entradas:
%   T       - tabela com o dataset
%   weights - vetor de pesos dos atributos
%
% Saídas:
%   T - tabela com o target imputado
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    % Determinar os nomes dos atributos de entrada
    inputVars = T.Properties.VariableNames;
    inputVars(strcmp(inputVars, 'class_cat')) = [];

    % Separação entre casos com target conhecido e desconhecido
    knownIdx   = ~ismissing(T.class_cat) & strlength(strtrim(string(T.class_cat))) > 0;
    unknownIdx = ~knownIdx;

    knownCases = T(knownIdx, :);

    % Percorrer todos os casos com classe desconhecida
    for i = find(unknownIdx)'
        newCase = T(i, :);

        bestSim = -inf;
        bestClass = "";

        % Procurar o caso mais semelhante na base de casos conhecidos
        for k = 1:height(knownCases)
            sim = globalSimilarity(newCase, knownCases(k,:), inputVars, weights);

            if sim > bestSim
                bestSim = sim;
                bestClass = string(knownCases.class_cat(k));
            end
        end

        % Atribuir ao target em falta a classe do caso mais semelhante
        T.class_cat(i) = bestClass;
    end
end