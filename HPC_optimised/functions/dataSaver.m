% Script to save the current data, clear the array and re-seed a new array
% and then make a readme.txt with the details of the simulation in.

function [PosS1,PosC1,PosStemp1,PosCtemp1] = dataSaver(PosS1, PosC1, n1, t1, in1, wTorq1)
    
    save(['data/' num2str(wTorq1) '/' num2str(in1) '/S_' num2str(n1) '.mat'],'PosS1');
    save(['data/' num2str(wTorq1) '/' num2str(in1) '/C_' num2str(n1) '.mat'],'PosC1');
    
    % re-seed the array and keep the last value in a temp store.
    PosStemp1 = PosS1(:,:,t1);
    PosCtemp1 = PosC1(:,:,t1);
    
end

