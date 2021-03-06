clear
clc

rng(1994)

data=load('bank.dat');

X= data(:,1:end-1);
Y= data(:,end);

[ranks,weights] = relieff(X,Y,200);
    
figure
bar(weights(ranks))
xlabel('Predictor rank')
ylabel('Predictor importance weight')
