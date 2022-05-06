function [PosSnew,dx,dy,dth] = RK2swimmer(PosSold1,PosSnew11,PosSnew21,dt1,Ns1,RS1,Ysi1,SWT1,Xsi1,k1,kickType1,SDV1,SBT1,polarity1,kickMethod1,stream)

    PosSnew = zeros(Ns1, 4);
    dx = 0;
    dy = 0;
    dth = 0;
    
    for i = 1:Ns1
        
        dx = 0.5*(PosSnew11(i,7)+PosSnew21(i,6));
        dy = 0.5*(PosSnew11(i,8)+PosSnew21(i,7));
        dth = 0.5*(PosSnew11(i,5)+PosSnew21(i,5)) + PosSnew11(i,6);
        
        %disp([num2str(dth) ' overall move'])
        PosSnew(i,1) = PosSold1(i,1) + dx;
        PosSnew(i,2) = PosSold1(i,2) + dy;
        PosSnew(i,3) = PosSold1(i,3) + dth;
        PosSnew(i,4) = PosSold1(i,4);
        
        % Ensure the angle of orientation is on 0 to pi.
        while abs(PosSnew(i,3)) >= 50000*pi
            n = floor(PosSnew(i,3)/(pi));
            if(~isinf(n))
                PosSnew(i,3) = PosSnew(i,3) - sign(PosSnew(i,3))*n*pi;
            else 
                PosSnew(i,3) = (rand(stream)-0.5)*4*pi;
            end
        end
        
        % Check the y boundary. Stopping boundary condition.
        s = sin(PosSnew(i,3));
        for j = 1:3           
            segLocMa = PosSnew(i,2) + SDV1(j)*s + RS1(j);
            segLocMi = PosSnew(i,2) + SDV1(j)*s - RS1(j);         
            if segLocMa > Ysi1/2 + RS1(j)*SBT1 
                dy = segLocMa - (Ysi1/2 + RS1(j)*SBT1);
                PosSnew(i,2) = PosSnew(i,2) - dy;
            elseif segLocMi < -Ysi1/2 - RS1(j)*SBT1 
                dy = segLocMi - (-Ysi1/2 - RS1(j)*SBT1);
                PosSnew(i,2) = PosSnew(i,2) - dy;
            end
        end
        
        % kicks from the boundary.
        % Probability of a kick check.
        p = 1-exp(-k1*dt1); % poisson probability.
        event = max(abs(PosSold1(i,5)),sign(p - rand(stream)));
        
        % Check the particle is in the right place to continue/start an
        % event.
        s1 = (sign( PosSnew(i,2) - (Ysi1/2 - SWT1) )  + 1)/2; % above the threshold.
        s2 = (sign( PosSnew(i,2) + (Ysi1/2 - SWT1) )  - 1)/2; % check if it's below.
        PosSnew(i,5) = event*(s1 + s2); % get the signed outcoome, multiply by the event check.
        
        % Boundary in x.
        while PosSnew(i,1) < -Xsi1/2
            PosSnew(i,1) = PosSnew(i,1) + Xsi1;
            PosSnew(i,4) = PosSnew(i,4) - 1;
        end
        while PosSnew(i,1) > Xsi1/2
            PosSnew(i,1) = PosSnew(i,1) - Xsi1;
            PosSnew(i,4) = PosSnew(i,4) + 1;
        end
        
    end

end

