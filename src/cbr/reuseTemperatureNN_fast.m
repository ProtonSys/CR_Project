function suggestedTemp = reuseTemperatureNN_fast(net, newCase)
% REUSETEMPERATURENN_FAST Prevê temperatura usando a rede treinada.
%
% Entradas:
%   net     - rede neuronal treinada
%   newCase - novo caso
%
% Saídas:
%   suggestedTemp - temperatura sugerida
%
% Autor: Celso Jordão
% nº 2003008910
% Unidade Curricular: Conhecimento e Raciocínio
% Trabalho Prático 2025/2026

    xNew = [ ...
        newCase.vibration; ...
        newCase.rotation_speed; ...
        newCase.voltage];

    suggestedTemp = net(xNew);

    suggestedTemp = double(suggestedTemp);
end