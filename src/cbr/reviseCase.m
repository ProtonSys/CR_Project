function updatedCase = reviseCase(newCase, suggestedTemp)
% REVISECASE Executa a etapa Revise do ciclo CBR.
%
% Esta função apresenta ao utilizador a temperatura sugerida pela rede
% neuronal e permite decidir se o valor deve substituir a temperatura
% original do caso.
%
% Entradas:
%   newCase      - novo caso
%   suggestedTemp - temperatura sugerida pela rede neuronal
%
% Saídas:
%   updatedCase - caso atualizado após revisão
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    % ---------------------------------------------------------------------
    % Inicialização do caso atualizado
    % ---------------------------------------------------------------------
    updatedCase = newCase;

    % ---------------------------------------------------------------------
    % Apresentação dos valores ao utilizador
    % ---------------------------------------------------------------------
    fprintf('\n========== REVISE ==========\n');

    fprintf( ...
        'Temperatura atual: %.4f\n', ...
        newCase.temperature);

    fprintf( ...
        'Temperatura sugerida: %.4f\n', ...
        suggestedTemp);

    % ---------------------------------------------------------------------
    % Decisão do utilizador
    % ---------------------------------------------------------------------
    op = input( ...
        'Pretende substituir a temperatura pelo valor sugerido? (1=Sim, 0=Não): ');

    % ---------------------------------------------------------------------
    % Atualização do caso
    % ---------------------------------------------------------------------
    if op == 1

        updatedCase.temperature = suggestedTemp;

        fprintf('Temperatura atualizada.\n');

    else

        fprintf('Temperatura mantida.\n');

    end
end