function [PosC1,dx,dy] = RK2colloid(PosCold1,PosCnew11,PosCnew21,Nc1,Ysi1,Xsi1,eps1,moMax1)

    PosC1 = zeros(Nc1,4);
    dx    = 0;
    dy    = 0;
    
    for i = 1:Nc1
        
        dx = 0.5*(PosCnew11(i,4)+PosCnew21(i,4)) + PosCnew11(i,5);
        dy = 0.5*(PosCnew11(i,6)+PosCnew21(i,5)) + PosCnew11(i,7);
        
        PosC1(i,1) = PosCold1(i,1) + dx;
        PosC1(i,2) = PosCold1(i,2) + dy;
        PosC1(i,3) = PosCold1(i,3);        
        PosC1(i,4) = max([abs(sign(PosCnew11(i,4))),abs(sign(PosCnew21(i,4))),abs(sign(PosCnew11(i,6))),abs(sign(PosCnew21(i,5)))]);
        
        % Check the y boundary. Stopping boundary condition.
        if PosC1(i,2) > Ysi1/2 - 0.2
            PosC1(i,2) = Ysi1/2 - 0.2;    
        elseif PosC1(i,2) < -Ysi1/2 + 0.2
            PosC1(i,2) = -Ysi1/2 + 0.2;
        end 
        
        % Boundary in x.
        if PosC1(i,1) < -Xsi1/2
            PosC1(i,1) = PosC1(i,1) + Xsi1;
            PosC1(i,3) = PosCold1(i,3) - 1;
        elseif PosC1(i,1) > Xsi1/2
            PosC1(i,1) = PosC1(i,1) - Xsi1;
            PosC1(i,3) = PosCold1(i,3) + 1;
        end
        
    end
    
end

