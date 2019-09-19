20190919  
1.删除了info_val.m文件，改用MATLAB自带的aicbic函数作为计算aic和bic的值的依据。
2.求差分时改用了diff函数，对应修改了一些转置变换
3.删掉了未用到的Options
4.获取到AR，MA的定阶值后，不应＋1
