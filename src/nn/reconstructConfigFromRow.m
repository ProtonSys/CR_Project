function cfg = reconstructConfigFromRow(row)
% RECONSTRUCTCONFIGFROMROW Reconstrói configuração a partir de tabela.
%
% Esta função converte uma linha da tabela de resultados numa estrutura
% de configuração utilizável para recriar a rede neuronal.
%
% Entradas:
%   row - linha da tabela de resultados
%
% Saídas:
%   cfg - estrutura da configuração
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    cfg = struct();

    cfg.hiddenLayers = str2num(char(row.HiddenLayers)); %#ok<ST2NM>
    cfg.trainFcn   = char(row.TrainFcn);
    cfg.outputFcn  = char(row.OutputFcn);
    cfg.trainRatio = row.TrainRatio;
    cfg.valRatio   = row.ValRatio;
    cfg.testRatio  = row.TestRatio;
    cfg.epochs     = row.Epochs;
    cfg.lr         = row.LR;
end