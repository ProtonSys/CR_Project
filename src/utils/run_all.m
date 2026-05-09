clc;
clear;
close all;

fprintf('\n');
fprintf('=============================================\n');
fprintf(' PROJETO CR - EXECUÇÃO COMPLETA\n');
fprintf('=============================================\n');

% -------------------------------------------------------------
% Adiciona todas as subpastas ao path
% -------------------------------------------------------------
addpath(genpath('src'));

% -------------------------------------------------------------
% Criar pasta results caso não exista
% -------------------------------------------------------------
if ~exist('results', 'dir')
    mkdir('results');
end

% -------------------------------------------------------------
% Criar pasta models caso não exista
% -------------------------------------------------------------
if ~exist('models', 'dir')
    mkdir('models');
end

fprintf('\n');
fprintf('=============================================\n');
fprintf(' 1. PRÉ-PROCESSAMENTO\n');
fprintf('=============================================\n');

try

    run('main_preprocess');

    fprintf('\n');
    fprintf('Pré-processamento concluído com sucesso.\n');

catch ME

    fprintf('\n');
    fprintf('Erro no pré-processamento:\n');
    disp(ME.message);

    return;

end

fprintf('\n');
fprintf('=============================================\n');
fprintf(' 2. EXPERIÊNCIAS CBR\n');
fprintf('=============================================\n');

try

    run('main_cbr_experiments');

    fprintf('\n');
    fprintf('Experiências CBR concluídas.\n');

catch ME

    fprintf('\n');
    fprintf('Erro nas experiências CBR:\n');
    disp(ME.message);

end

fprintf('\n');
fprintf('=============================================\n');
fprintf(' 3. EXPERIÊNCIAS REDES NEURONAIS\n');
fprintf('=============================================\n');

try

    run('main_nn_experiments');

    fprintf('\n');
    fprintf('Experiências RN concluídas.\n');

catch ME

    fprintf('\n');
    fprintf('Erro nas redes neuronais:\n');
    disp(ME.message);

end

fprintf('\n');
fprintf('=============================================\n');
fprintf(' 4. COMPARAÇÃO RAW VS NORMALIZED\n');
fprintf('=============================================\n');

try

    run('main_compare_best_worst');

    fprintf('\n');
    fprintf('Comparação concluída.\n');

catch ME

    fprintf('\n');
    fprintf('Erro na comparação:\n');
    disp(ME.message);

end

fprintf('\n');
fprintf('=============================================\n');
fprintf(' 5. TESTE DAS MELHORES REDES\n');
fprintf('=============================================\n');

try

    run('main_test_best_networks');

    fprintf('\n');
    fprintf('Teste final concluído.\n');

catch ME

    fprintf('\n');
    fprintf('Erro no teste final:\n');
    disp(ME.message);

end

fprintf('\n');
fprintf('=============================================\n');
fprintf(' EXECUÇÃO TERMINADA\n');
fprintf('=============================================\n');

fprintf('\n');
fprintf('Resultados disponíveis em:\n');
fprintf(' - results/\n');
fprintf(' - models/\n');
fprintf('\n');