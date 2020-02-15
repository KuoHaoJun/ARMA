代码运行环境：
MATLAB2019a
获取ARMA_Order_Select.m和ARMA_Order_Select_Diff.m的源码请查看source.txt

常见问题：
使用MATLAB2018及以下版本时，调用forecast时会报错：“需要字符串标量或字符向量形式的参数名称。”
解决方法：
例如ARMS_Forecast第68行，修改为Predict_dlogY(i+1) = forecast(EstMdl,1,'Y0',aimY(1:i));即可

代码说明：
ARMA_Forecast和ARMA_Order_Select是1组，用了log和差分，再还原
ARMA_Forecast_Diff和ARMA_Order_Select_Diff是1组，只取了差分，没有用还原

20190919  
1.删除了info_val.m文件，改用MATLAB自带的aicbic函数作为计算aic和bic的值的依据。
2.求差分时改用了diff函数，对应修改了一些转置变换
3.删掉了未用到的Options
4.获取到AR，MA的定阶值后，不应＋1