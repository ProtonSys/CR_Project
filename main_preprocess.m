clc;
clear;
close all;

% =========================================================================
% MAIN_PREPROCESS
% =========================================================================
%
% Este script realiza o pré-processamento completo do dataset utilizado
% no trabalho prático.
%
% As principais etapas executadas são:
%   1) Conversão de atributos categóricos para representação numérica
%   2) Preenchimento de missing values nos atributos de entrada
%   3) Preenchimento de missing values no target usando CBR
%   4) Normalização dos atributos de entrada
%
% No final são gerados:
%   - dataset tratado
%   - dataset tratado e normalizado
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026
%
% =========================================================================

% Limpeza do ambiente MATLAB:
%   - clc: limpa a consola
%   - clear: remove variáveis da memória
%   - close all: fecha figuras abertas

% -------------------------------------------------------------------------
% Adicionar todas as subpastas do projeto ao path
% -------------------------------------------------------------------------
% Permite utilizar automaticamente todas as funções presentes
% nas subpastas da pasta src.
addpath(genpath('src'));

% -------------------------------------------------------------------------
% Definição dos caminhos dos ficheiros
% -------------------------------------------------------------------------
% Dataset original
inputFile = fullfile('data', 'dataset_TP.csv');

% Dataset tratado
outputRaw = fullfile('data', 'dataset_TP_tratado.csv');

% Dataset tratado e normalizado
outputNorm = fullfile('data', 'dataset_TP_tratado_normalizado.csv');

% -------------------------------------------------------------------------
% Leitura do dataset original
% -------------------------------------------------------------------------
% O dataset é carregado para uma tabela MATLAB.
% A opção 'TextType','string' garante que os atributos textuais
% sejam carregados como strings.
T = readtable(inputFile, 'TextType', 'string');

fprintf( ...
    'Dataset original carregado com %d linhas e %d colunas.\n', ...
    height(T), ...
    width(T));

% -------------------------------------------------------------------------
% ETAPA 1 - Conversão dos atributos categóricos
% -------------------------------------------------------------------------
% Os atributos categóricos são convertidos para representação numérica.
%
% Esta etapa é necessária porque:
%   - o cálculo de similaridades do CBR requer valores numéricos
%   - as redes neuronais trabalham apenas com entradas numéricas
%
% Nos atributos ordinais é preservada a relação semântica entre valores.
T = encodeCategoricalColumns(T);

% -------------------------------------------------------------------------
% ETAPA 2 - Preenchimento dos missing values dos inputs
% -------------------------------------------------------------------------
% Os valores em falta nos atributos de entrada são preenchidos.
%
% Estratégia utilizada:
%   - mediana para atributos numéricos
%   - moda para atributos categóricos
%
% A mediana foi escolhida por ser mais robusta a outliers.
T = fillMissingInputs(T);

% -------------------------------------------------------------------------
% ETAPA 3 - Preenchimento dos missing values do target com CBR
% -------------------------------------------------------------------------
% O target em falta é imputado utilizando raciocínio baseado em casos.
%
% Para cada caso sem classe:
%   - procura-se o caso conhecido mais semelhante
%   - copia-se a classe desse caso
%
% Esta abordagem respeita o enunciado do trabalho.
weights = getAttributesWeights();

T = fillMissingTargetCBR(T, weights);

% -------------------------------------------------------------------------
% Guarda do dataset tratado
% -------------------------------------------------------------------------
writetable(T, outputRaw);

fprintf('Dataset tratado guardado em: %s\n', outputRaw);

% -------------------------------------------------------------------------
% ETAPA 4 - Normalização dos atributos de entrada
% -------------------------------------------------------------------------
% É criada uma versão normalizada do dataset.
%
% Apenas os atributos de entrada são normalizados.
% A coluna target não é normalizada.
%
% A normalização permite:
%   - reduzir diferenças de escala entre atributos
%   - melhorar o comportamento do CBR
%   - melhorar o treino das redes neuronais
T_norm = normalizeInputColumns(T);

% -------------------------------------------------------------------------
% Guarda do dataset normalizado
% -------------------------------------------------------------------------
writetable(T_norm, outputNorm);

fprintf( ...
    'Dataset tratado normalizado guardado em: %s\n', ...
    outputNorm);