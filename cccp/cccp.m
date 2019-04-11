clear 
clc

rng(1994)
%% Load data - Split data
data=load('CCCP.dat');
preproc=1;
[trnData,chkData,tstData]=split_scale(data,preproc);
Perf=zeros(4,4);

%% Evaluation function
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);

%%
fis=genfis1(trnData,2,'gbellmf','constant');
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9],[],chkData);

figure
plotMFs(trnFis,size(trnData,2)-1);

% Validation
figure
plot([trnError valError],'LineWidth',2); grid on;
xlabel('# of Iterations'); ylabel('Error');
legend('Training Error','Validation Error');
title('MFs:2- Output constant | Validation');

Y=evalfis(chkData(:,1:end-1),valFis);
R2=Rsq(Y,chkData(:,end));
RMSE=sqrt(mse(Y,chkData(:,end)));
NMSE=mean((Y-chkData(:,end)).^2)/mean((Y-mean(Y)).^2);
NDEI=sqrt(NMSE);
Perf(:,1)=[R2;RMSE;NMSE;NDEI];


%%
fis=genfis1(trnData,2,'gbellmf','linear');
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9],[],chkData);

plotMFs(trnFis,size(trnData,2)-1);

% Validation
figure
plot([trnError valError],'LineWidth',2); grid on;
xlabel('# of Iterations'); ylabel('Error');
legend('Training Error','Validation Error');
title('MFs:2- Output linear | Validation');

Y=evalfis(chkData(:,1:end-1),valFis);
R2=Rsq(Y,chkData(:,end));
RMSE=sqrt(mse(Y,chkData(:,end)));
NMSE=mean((Y-chkData(:,end)).^2)/mean((Y-mean(Y)).^2);
NDEI=sqrt(NMSE);
Perf(:,2)=[R2;RMSE;NMSE;NDEI];

%%
fis=genfis1(trnData,3,'gbellmf','constant');
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9],[],chkData);

plotMFs(valFis,size(trnData,2)-1);

% Validation
figure
plot([trnError valError],'LineWidth',2); grid on;
xlabel('# of Iterations'); ylabel('Error');
legend('Training Error','Validation Error');
title('MFs:3- Output constant | Validation');

Y=evalfis(chkData(:,1:end-1),valFis);
R2=Rsq(Y,chkData(:,end));
RMSE=sqrt(mse(Y,chkData(:,end)));
NMSE=mean((Y-chkData(:,end)).^2)/mean((Y-mean(Y)).^2);
NDEI=sqrt(NMSE);
Perf(:,3)=[R2;RMSE;NMSE;NDEI];

%%
fis=genfis1(trnData,3,'gbellmf','linear');
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9],[],chkData);

plotMFs(valFis,size(trnData,2)-1);

% Validation
figure
plot([trnError valError],'LineWidth',2); grid on;
xlabel('# of Iterations'); ylabel('Error');
legend('Training Error','Validation Error');
title('MFs:3- Output linear | Validation');

Y=evalfis(chkData(:,1:end-1),valFis);
R2=Rsq(Y,chkData(:,end));
RMSE=sqrt(mse(Y,chkData(:,end)));
NMSE=mean((Y-chkData(:,end)).^2)/mean((Y-mean(Y)).^2);
NDEI=sqrt(NMSE);
Perf(:,4)=[R2;RMSE;NMSE;NDEI];