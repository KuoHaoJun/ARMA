%% 进行预测的程序
%  与ARMA_Forcast.m不同，该程序不取对数，使用n阶差分的方法使序列平稳
%  Copyright (c) 2019 Mr.括号 All rights reserved.
%  原文链接 https://zhuanlan.zhihu.com/p/69630638
%  代码地址：https://github.com/KuoHaoJun/ARMA
%% 1.导入数据
close all
clear all
load Data_EquityIdx   %纳斯达克综合指数
len = 120;
Y = DataTable.NASDAQ(1:len);
plot(Y)
%% 2.平稳性检验
% 原数据
y_h_adf = adftest(Y)
y_h_kpss = kpsstest(Y)
% 一阶差分，结果平稳。如果依旧不平稳的话，再次求差分，直至通过检验
Yd1 = diff(Y);
yd1_h_adf = adftest(Yd1)
yd1_h_kpss = kpsstest(Yd1)

%% 3.确定ARMA模型阶数
% ACF和PACF法，确定阶数
figure
autocorr(Y)
figure
parcorr(Y)
% 通过AIC，BIC等准则暴力选定阶数
max_ar = 3;
max_ma = 3;
[AR_Order,MA_Order] = ARMA_Order_Select_Diff(Y,max_ar,max_ma,1);      %dY需要为列向量,获取ARMA_Order_Select_Diff源码请查看source.txt
%% 4.残差检验
Mdl = arima(AR_Order, 1, MA_Order);  %第二个变量值为1，即一阶差分
EstMdl = estimate(Mdl,Y);
[res,~,logL] = infer(EstMdl,Y);   %res即残差

stdr = res/sqrt(EstMdl.Variance);
figure('Name','残差检验')
subplot(2,3,1)
plot(stdr)
title('Standardized Residuals')
subplot(2,3,2)
histogram(stdr,10)
title('Standardized Residuals')
subplot(2,3,3)
autocorr(stdr)
subplot(2,3,4)
parcorr(stdr)
subplot(2,3,5)
qqplot(stdr)
% Durbin-Watson 统计是计量经济学分析中最常用的自相关度量
diffRes0 = diff(res);  
SSE0 = res'*res;
DW0 = (diffRes0'*diffRes0)/SSE0 % Durbin-Watson statistic，该值接近2，则可以认为序列不存在一阶相关性。
%% 5.预测
% 单步预测
for i = 5:length(Y)
    Predict_Y(i+1) = forecast(EstMdl,1,Y(1:i));   %matlab2018及以下版本写为Predict_Y(i+1) = forecast(EstMdl,1,'Y0',Y(1:i)); 
end
figure
plot(Y)
hold on
plot(6:length(Predict_Y),Predict_Y(6:length(Predict_Y)))