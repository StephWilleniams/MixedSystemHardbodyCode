% Function to move the colloids, works by implementing a force due to the
% yukawa potential and some thermal noise. Then checks the boundaries.


function [PosCnew] = moveColloid1(PosCold1,DuDiC1,Nc1,FC1,dt1,DC1,mM1,Ysi1,Xsi1,eps1,moMax1,stream)

    PosCnew = zeros(Nc1,7); % Initalise store for new colloid positions.

    % Loop over each of the colloids.
    for i = 1:Nc1
        
        % Increment the moves, remove nonsensical moves with a cap.
        nx = sqrt(2*DC1*dt1)*randn(stream);
        dx = dt1*DuDiC1(i,1)*FC1 + nx;
        dx = sign(dx)*min(abs(dx),mM1);
        
        ny = sqrt(2*DC1*dt1)*randn(stream);
        dy = dt1*DuDiC1(i,2)*FC1 + ny;
        dy = sign(dy)*min(abs(dy),mM1);
        
        PosCnew(i,1) = PosCold1(i,1) + dx; % New x pos.
        PosCnew(i,4) = dt1*DuDiC1(i,1)*FC1;
        PosCnew(i,5) = nx;
        PosCnew(i,2) = PosCold1(i,2) + dy; % New y pos.
        PosCnew(i,6) = dt1*DuDiC1(i,2)*FC1;
        PosCnew(i,7) = ny;
        
        % Check the y boundary. Stopping boundary condition.
        if PosCnew(i,2) >= Ysi1/2 + eps1          
            PosCnew(i,2) = Ysi1/2 + eps1;            
        elseif PosCnew(i,2) <= -Ysi1/2 - eps1          
            PosCnew(i,2) = -Ysi1/2 - eps1;
        end 
        
        % Boundary in x.
        if PosCnew(i,1) < -Xsi1/2
            PosCnew(i,1) = PosCnew(i,1) + Xsi1;
        elseif PosCnew(i,1) > Xsi1/2
            PosCnew(i,1) = PosCnew(i,1) - Xsi1;
        end
    
    end

end

