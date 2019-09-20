%% 进行预测的程序
%  目标为退化的特征值，即TimeValFil中的各个值
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
% 取log
Ylog = log(Y)
ylog_h_adf = adftest(Ylog)
ylog_h_kpss = kpsstest(Ylog)
% 取log+差分
dYlog = diff(Ylog);

dylog_h_adf = adftest(dYlog)
dylog_h_kpss = kpsstest(dYlog)
% 取差分
dY = diff(Y);
dy_h_adf = adftest(dY)
dy_h_kpss = kpsstest(dY)

aimY = dYlog;  %选定了log+差分作为分析目标数据
%% 3.确定ARMA模型阶数
% ACF和PACF法，确定阶数
figure
autocorr(aimY)
figure
parcorr(aimY)
% 通过AIC，BIC等准则暴力选定阶数
max_ar = 3;
max_ma = 3;
[AR_Order,MA_Order] = ARMA_Order_Select(aimY,max_ar,max_ma)   %dY需要为列向量
%% 4.残差检验
Mdl = arima(AR_Order, 0, MA_Order);
EstMdl = estimate(Mdl,aimY);
[res,~,logL] = infer(EstMdl,aimY);   %res即残差

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
for i = 5:length(aimY)
    Predict_dlogY(i+1) = forecast(EstMdl,1,aimY(1:i));  %matlab2018及以下版本写为Predict_dlogY(i+1) = forecast(EstMdl,1,'Y0',aimY(1:i));
end
figure
plot(aimY);
hold on
Predict_dlogY(1:5)=0;
plot(1:length(aimY),Predict_dlogY(1:length(aimY)))
% 还原
for i = 1:(length(aimY)+1)
    Predict_ylog(i) = log(Y(1))+ sum(aimY(1:(i-1)))+Predict_dlogY(i);  %差分还原
end
Predict_y = exp(Predict_ylog); %对数还原
figure
plot(Y)
hold on
plot(Predict_y)
% 计算准确率
figure
plot((Predict_y'-Y)/Y)

% 多步预测
[Predict_mul_dlogY,YMSE] = forecast(EstMdl,10,aimY');   %使用当前所有数据，预测未来10个步长的数据  %matlab2018及以下版本写为[Predict_mul_dlogY,YMSE] = forecast(EstMdl,10,'Y0',aimY'); 
% 还原
for i = 1:10
    Predict_mul_ylog(i) = log(Y(1))+ sum(aimY)+sum(Predict_mul_dlogY(1:i));  %差分还原
end
Predict_mul_y = exp(Predict_mul_ylog);
figure
plot(DataTable.NASDAQ(1:len+10));  %将原始数据的点之后10个点画出，注意这10个数据在训练模型时没用用到，且为真实历史数据，用以对比多步预测的准确性
hold on
plot(len:len+10,[Y(length(Y)),Predict_mul_y])