% Function to set the translational friction coefficient of the swimmers. 

function [FTS] = setFriction(FS1,posSold1)

    FTS = zeros(2,2); % Reset the matrix.
    c = cos(posSold1(:,3));
    s = sin(posSold1(:,3));
    FTS(1,1) = sum( FS1(1).* c.^2 + FS1(2)*(1-c.^2));
    FTS(1,2) = sum( FS1(1).* c.*s - FS1(2).*c.*s);
    FTS(2,1) = sum( FS1(1).* c.*s - FS1(2).*c.*s);
    FTS(2,2) = sum( FS1(1).* s.^2 + FS1(2).*(1-s.^2));

end

