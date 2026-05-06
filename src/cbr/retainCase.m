function T = retainCase(T, updatedCase)
% RETAINCASE Executa a etapa Retain do ciclo CBR.
%
% Esta função permite ao utilizador decidir se o novo caso deve ser
% acrescentado à base de casos.
%
% Caso o utilizador aceite:
%   - o caso é adicionado ao dataset
%
% Caso contrário:
%   - o dataset permanece inalterado
%
% Entradas:
%   T           - base de casos atual
%   updatedCase - novo caso após revisão
%
% Saídas:
%   T - base de casos atualizada
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    % ---------------------------------------------------------------------
    % Pedido de confirmação ao utilizador
    % ---------------------------------------------------------------------
    fprintf('\n========== RETAIN ==========\n');

    op = input( ...
        'Pretende acrescentar este novo caso ao dataset? (1=Sim, 0=Não): ');

    % ---------------------------------------------------------------------
    % Atualização da base de casos
    % ---------------------------------------------------------------------
    if op == 1

        % Adicionar novo caso à tabela
        T = [T; updatedCase];

        fprintf('Novo caso acrescentado ao dataset.\n');

    else

        fprintf('Novo caso não foi acrescentado.\n');

    end
end