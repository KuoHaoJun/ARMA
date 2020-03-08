%% 进行预测的程序
%  知乎专栏中的单步预测代码。为脚本文件，可以直接运行。
%  Copyright (c) 2019 Mr.括号 All rights reserved.
%  原文链接 https://zhuanlan.zhihu.com/p/69630638
%  代码地址：https://github.com/KuoHaoJun/ARMA
%% 1.导入数据
close all
clear all
load Data_EquityIdx   %纳斯达克综合指数
len = 1200;
data = DataTable.NASDAQ(1:len);
plot(data)
%% 2.平稳性检验
% 原数据
y_h_adf = adftest(data)
y_h_kpss = kpsstest(data)
% 一阶差分，结果平稳。如果依旧不平稳的话，再次求差分，直至通过检验
Yd1 = diff(data);
yd1_h_adf = adftest(Yd1)
yd1_h_kpss = kpsstest(Yd1)
Y = diff(data);
%% 3.确定ARMA模型阶数
% ACF和PACF法，确定阶数
figure
autocorr(Y)
figure
parcorr(Y)
% 通过AIC，BIC等准则暴力选定阶数
max_ar = 3;
max_ma = 3;
[AR_Order,MA_Order] = ARMA_Order_Select(Y,max_ar,max_ma,1);      
%% 4.残差检验
Mdl = arima(AR_Order, 1, MA_Order);  %第二个变量值为1，即一阶差分
EstMdl = estimate(Mdl,data);
[res,~,logL] = infer(EstMdl,data);   %res即残差

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
step = 300;
[forData,YMSE] = forecast(EstMdl,step,'Y0',data);   %matlab2019写为[forData,YMSE] = forecast(EstMdl,step,data); 
lower = forData - 1.96*sqrt(YMSE); %95置信区间下限
upper = forData + 1.96*sqrt(YMSE); %95置信区间上限

figure()
plot(data,'Color',[.7,.7,.7]);
hold on
h1 = plot(length(data):length(data)+step,[data(end);lower],'r:','LineWidth',2);
plot(length(data):length(data)+step,[data(end);upper],'r:','LineWidth',2)
h2 = plot(length(data):length(data)+step,[data(end);forData],'k','LineWidth',2);
legend([h1 h2],'95% 置信区间','预测值',...
	     'Location','NorthWest')
title('Forecast')
hold off