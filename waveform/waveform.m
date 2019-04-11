clear 
clc

rng(1994)

%% Load data - Split data
import = load('waveform.dat');
data = import(:,4:18);
data = [data import(:,24)];
data = [data import(:,38)];
data = [data import(:,41)];

preproc=1;
[trnData,chkData,tstData]=split_scale(data,preproc);

%% ANFIS - Scatter Partition
%%Clustering Per Class
radius=0.8;
[c1,sig1]=subclust(trnData(trnData(:,end)==0,:),radius);
[c2,sig2]=subclust(trnData(trnData(:,end)==1,:),radius);
[c3,sig3]=subclust(trnData(trnData(:,end)==1,:),radius);
num_rules=size(c1,1)+size(c2,1)+size(c3,1);

%Build FIS From Scratch
fis=newfis('FIS_SC','sugeno');

%Add Input-Output Variables
names_in={'in1','in2','in3','in4','in5','in6','in7','in8','in9','in10','in11','in12','in13','in14','in15','in16','in17'};
for i=1:17
    fis=addvar(fis,'input',names_in{i},[0 1 2]);
end
fis=addvar(fis,'output','out1',[0 1 2]);

%Add Input Membership Functions
name='';
for i=1:size(trnData,2)-1
    for j=1:size(c1,1)
        fis=addmf(fis,'input',i,name,'gaussmf',[sig1(j) c1(j,i)]);
    end
    for j=1:size(c2,1)
        fis=addmf(fis,'input',i,name,'gaussmf',[sig2(j) c2(j,i)]);
    end
    for j=1:size(c3,1)
        fis=addmf(fis,'input',i,name,'gaussmf',[sig3(j) c3(j,i)]);
    end
end

%Add Output Membership Functions
params=[zeros(1,size(c1,1)) ones(1,size(c2,1)) ones(1,size(c2,1))+1];
for i=1:num_rules
    fis=addmf(fis,'output',1,name,'constant',params(i));
end

%Add FIS Rule Base
ruleList=zeros(num_rules,size(trnData,2));
for i=1:size(ruleList,1)
    ruleList(i,:)=i;
end
ruleList=[ruleList ones(num_rules,2)];
fis=addrule(fis,ruleList);

%%%%%%plotMFs(fis,size(trnData,2)-1);

%Train & Evaluate ANFIS
[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[100 0 0.01 0.9 1.1],[],chkData);

%%%%%%plotMFs(trnFis,size(trnData,2)-1);

%%
plot([trnError valError],'LineWidth',2); grid on;
legend('Training Error','Validation Error');
xlabel('# of Epochs');
ylabel('Error');
title('ANFIS Classification with Grid Partition');

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
for i=1:3
   PA(i) = EM(i,i)/Xjc(i);
   UA(i) = EM(i,i)/Xir(i);
end

K = (length(Y)*sum(diag(EM)) - sum(Xir.*Xjc))/(length(Y)*length(Y) - sum(Xir.*Xjc));

%fis=genfis1(trnData,3,'gaussmf','constant');
%[trnFis,trnError,~,valFis,valError]=anfis(trnData,fis,[],[],chkData);






