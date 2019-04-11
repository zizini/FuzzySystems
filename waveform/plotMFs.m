%% Plot Membership Functions of FIS

function  plotMFs(fis,num_in)
    figure
    for i=1:num_in
            subplot(4,2,i);
            plotmf(fis,'input',i); grid on;
    end
end