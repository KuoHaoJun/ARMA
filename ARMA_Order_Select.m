function [AR_Order,MA_Order] = ARMA_Order_Select(data,max_ar,max_ma)
% 通过AIC，BIC等准则暴力选定阶数
% 输入：
% data对象数据
% max_ar为AR模型搜寻的最大阶数
% max_ma为MA模型搜寻的最大阶数
% 输出：
% AR_Orderr为AR模型输出阶数
% MA_Orderr为AR模型输出阶数
T = length(data);
Options = optimoptions(@fmincon,'MaxIter',2000, 'MaxFunEvals', 2000, ...
    'Display', 'notify', 'TolCon', 1e-12, 'TolFun', 1e-12, ...
    'TolX', 1e-12);
for ar = 0:max_ar
    for ma = 0:max_ma
        Mdl = arima(ar, 0, ma);
        [~, ~, LogL] = estimate(Mdl, data, 'Options', Options);
        % Compute the different information criterion for the 3 models
        infoC = info_val(LogL, (ar+ma), T);
        infoC_Sum(ar+1,ma+1) = sum(infoC);  %这里直接将三个参数求和，也可以只以其中一个参数为基准
    end
end
[x, y]=find(infoC_Sum==min(min(infoC_Sum)));
AR_Order = x -1;
MA_Order = y -1;
end