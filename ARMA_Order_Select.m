function [AR_Order,MA_Order] = ARMA_Order_Select(data,max_ar,max_ma)
% Copyright (c) 2019 Mr.括号 All rights reserved.
% 原文链接 https://zhuanlan.zhihu.com/p/69630638
% 代码地址：https://github.com/KuoHaoJun/ARMA
% 通过AIC，BIC等准则暴力选定阶数
% 输入：
% data对象数据
% max_ar为AR模型搜寻的最大阶数
% max_ma为MA模型搜寻的最大阶数
% 输出：
% AR_Orderr为AR模型输出阶数
% MA_Orderr为AR模型输出阶数

T = length(data);

for ar = 0:max_ar
    for ma = 0:max_ma
        if ar==0&&ma==0
            infoC_Sum = NaN;
            continue
        end
        Mdl = arima(ar, 0, ma);
        [~, ~, LogL] = estimate(Mdl, data, 'Display', 'off');
        [aic,bic] = aicbic(LogL,(ar+ma),T);
        infoC_Sum(ar+1,ma+1) = bic+aic;  %以BIC和AIC之和为标准进行选取 Select the sum of BIC and AIC as the standard
    end
end
[x, y]=find(infoC_Sum==min(min(infoC_Sum)));
AR_Order = x -1;
MA_Order = y -1;
end