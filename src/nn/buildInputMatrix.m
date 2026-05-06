function X = buildInputMatrix(T)
% BUILDINPUTMATRIX Constrói a matriz de entrada para a rede neuronal.
%
% Remove a coluna target da tabela e converte os restantes atributos numa
% matriz numérica organizada no formato esperado pelo MATLAB:
% colunas correspondem a amostras e linhas a atributos.
%
% Entradas:
%   T - tabela com os dados
%
% Saídas:
%   X - matriz de entrada da rede
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    vars = T.Properties.VariableNames;
    vars(strcmp(vars, 'class_cat')) = [];

    X = table2array(T(:, vars))';
end