function s = configToString(cfg)
% CONFIGTOSTRING Converte configuração da rede em texto.
%
% Esta função cria uma representação textual resumida de uma
% configuração de rede neuronal.
%
% Entradas:
%   cfg - estrutura da configuração
%
% Saídas:
%   s - string descritiva da configuração
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026


    h = sprintf('%d_', cfg.hiddenLayers);
    h(end) = [];

    s = sprintf('H[%s]_TR[%s]_OUT[%s]_DIV[%.0f-%.0f-%.0f]_EP[%d]_LR[%.3f]', ...
        h, cfg.trainFcn, cfg.outputFcn, ...
        cfg.trainRatio*100, cfg.valRatio*100, cfg.testRatio*100, ...
        cfg.epochs, cfg.lr);
end