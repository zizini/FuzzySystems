clear 
clc

%% Load data - Split data
data=load('wifi-localization.dat');
preproc=1;
[trnData,chkData,tstData]=split_scale(data,preproc);

%Compare with Class-Independent Scatter Partition
radius=0.5;
%radius=1;
fis=genfis2(trnData(:,1:end-1),trnData(:,end),radius);
plotMFs(fis,size(trnData,2)-1);

[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9 1.1],[],chkData);
plotMFs(trnFis,size(trnData,2)-1);

figure
plot([trnError valError],'LineWidth',2); grid on;
legend('Training Error','Validation Error');
xlabel('# of Epochs');
ylabel('Error');

Y=evalfis(tstData(:,1:end-1),valFis);
Y=round(Y);

diff=tstData(:,end)-Y;
Acc=(length(diff)-nnz(diff))/length(Y)*100;

%Confusion Matrix 
CM = confusionmat(tstData(:,end),Y);

%Error Matrix
EM = CM';

%Overall accuracy
OA = sum(diag(EM))/length(Y)*100;

%Producer's accuracy- User's accuracy
Xir = sum(EM,2);
Xir = Xir';
Xjc = sum(EM);
for i=1:4
   PA(i) = EM(i,i)/Xjc(i);
   UA(i) = EM(i,i)/Xir(i);
end

K = (length(Y)*sum(diag(EM)) - sum(Xir.*Xjc))/(length(Y)*length(Y) - sum(Xir.*Xjc));