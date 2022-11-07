function [ImOut]=fhtrack_adjustcontrast(ImIn,ImCLimGamma)

ImIn=fhtrack_NormIm(ImIn.^ImCLimGamma(1,3));
ImOut=max(min((ImIn-ImCLimGamma(1,1))/(ImCLimGamma(1,2)-ImCLimGamma(1,1)),1),0);