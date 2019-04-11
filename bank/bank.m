clear
clc

rng(1994)

import = load('bank.dat');
data = import(:,6);
data = [data import(:,12)];
data = [data import(:,18:19)];
data = [data import(:,23)];
data = [data import(:,27)];
data = [data import(:,33)];

preproc=1;
[trnData,chkData,tstData]=split_scale(data,preproc);

%% Evaluation function
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);

%% Scatter Partition - Subtractive Clustering
fis=genfis2(trnData(:,1:end-1),trnData(:,end),0.3);

plotMFs(fis,size(trnData,2)-1);

[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[],[],chkData);

plotMFs(valFis,size(trnData,2)-1);

figure;
plot([trnError valError],'LineWidth',2); grid on;
xlabel('# of Iterations'); ylabel('Error');
legend('Training Error','Validation Error');
title('Training - Validation');

Y=evalfis(chkData(:,1:end-1),valFis);
R2=Rsq(Y,chkData(:,end));
RMSE=sqrt(mse(Y,chkData(:,end)));
NMSE=mean((Y-chkData(:,end)).^2)/mean((Y-mean(Y)).^2);
NDEI=sqrt(NMSE);