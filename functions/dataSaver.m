% Script to save the current data, clear the array and re-seed a new array
% and then make a readme.txt with the details of the simulation in.

function [PosS1,PosC1,PosStemp1,PosCtemp1] = dataSaver(PosS1, PosC1, t1,seedNum1)
    
    save(['data/S_' num2str(seedNum1) '.mat'],'PosS1');
    save(['data/C_' num2str(seedNum1) '.mat'],'PosC1');
    
    % re-seed the array and keep the last value in a temp store.
    PosStemp1 = PosS1(:,:,t1);
    PosCtemp1 = PosC1(:,:,t1);
    
end

