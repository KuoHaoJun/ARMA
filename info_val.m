% Input:   logL = log Likelihood from estimation
%         param = number of parameters
%             T = number of observations
% Output: infoC = values of the information criteria

function infoC = info_val(logL, param, T)
AIC = -2*(logL/T) + 2*(param + 2)/T;
BIC = -2*(logL/T) + (param + 2)*log(T)/T;
HQ = -2*(logL/T) + 2*(param + 2)*log(log(T))/T;
infoC = [AIC, BIC, HQ];