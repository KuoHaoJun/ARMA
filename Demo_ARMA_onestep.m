%% 使用Fun_ARIMA_Forecast函数实现预测
% 单步预测
%  Copyright (c) 2019 Mr.括号 All rights reserved.
%  原文链接 https://zhuanlan.zhihu.com/p/69630638

close all
clear all
addpath ../funs %将funs文件夹添加进路径
load Data_EquityIdx   %纳斯达克综合指数
len = 100;
data = DataTable.NASDAQ(1:len); %如果要替换数据，将此处data替换即可。
forData1 = zeros(1,len); %全部初始化为0
for i = 30:len
    forData1(i+1) = Fun_ARIMA_Forecast(data(1:i),1,2,2,'off');
end
figure()
plot(31:len,data(31:len))
hold on
plot(31:len,forData1(31:len))
legend('原始数据','单步预测数据')
