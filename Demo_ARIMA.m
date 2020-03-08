%% 使用Fun_ARIMA_Forecast函数实现预测
%  原文链接 https://zhuanlan.zhihu.com/p/69630638

close all
clear all
addpath ../funs %将funs文件夹添加进路径
load Data_EquityIdx   %纳斯达克综合指数
data = DataTable.NASDAQ(1:1200); %如果要替换数据，将此处data替换即可。
[forData1,lower1,upper1] = Fun_ARIMA_Forecast(data,300,3,3,'on'); %预测未来n步数据，p，q上限为3,3。该函数的参数信息请在函数文件内查看
