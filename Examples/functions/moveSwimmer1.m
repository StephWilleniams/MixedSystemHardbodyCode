% Function to implement the motion of the swimmers. Proceeds in the
% following way. From the swimmers orientation get a projection matrix to
% convert the potental gradients into the frame of the swimmer's motion.
% This is then used to get the perp/parallel components of the potential
% gradient and then using the friction, swimmer motion and the noise the
% new position is calculated. After which the Hard boundaries are
% implemented. Once this is done swimmers close to the boundary undergo a
% kick if they pass a poisson probability check. Then the x boundary is
% checked and if it's passed the swimmer boundary crossing number is
% modified.

function [PosSnew] = moveSwimmer1(PosSold1,DuDiS1,Ns1,FS1,dt1,DSr1,FTSi1,VS1,SWT1,Ysi1,Xsi1,k1,RS1,moMax1,kickType1,SDV1,SBT1,polarity1,kickMethod1,wTorq01,stream)

    PosSnew = zeros(Ns1,8); % Initialise store for new postions.
    %P = zeros(2,2); % Initialise projection matrix store.
    %PDu = zeros(2,1); % Initialise projected potential gradients store.
    
    % Loop on each of the swimmers.
    for i = 1:Ns1
       
        phi = PosSold1(i,3); % Swimmer's orientation.     
        c = cos(phi); % cos of orientation.
        s = sin(phi); % sin of orientation.   
        %P = [1-c^2, -c*s; -s*c, 1-s^2]; % Ortientation projection matrix in the swimmer direction.
        P = [1,0;0,1];
        
        % Get the swimmer's new orientation.
        mu = sqrt(2*DSr1*dt1)*randn(stream);
        dth = sign(tan(PosSold1(i,3)))*dt1 * FS1(3) * DuDiS1(i,3) + mu;
        
        % implement wall torque for the kicks.
        oriIndic = -PosSold1(i,5)*sign(cos(PosSold1(i,3)));
        wTorq = oriIndic*wTorq01;
        
        PosSnew(i,3) = phi - dth + wTorq*dt1;
        
        while abs(PosSnew(i,3)) >= 50000*pi
            n = floor(PosSnew(i,3)/(pi));
            if(~isinf(n))
                PosSnew(i,3) = PosSnew(i,3) - sign(PosSnew(i,3))*n*pi;
            else 
                PosSnew(i,3) = (rand(stream)-0.5)*4*pi;
            end
        end
        PosSnew(i,5) = -dt1 * FS1(3) * DuDiS1(i,3) + wTorq*dt1;
        PosSnew(i,6) = mu;
        
        % Get the potential gradients in the swimmer direction.
        PDu = P*[DuDiS1(i,1);DuDiS1(i,2)];
        
        % Use the friction and swimmer speed to get the new swimmer
        % locations.
        dx = (FTSi1(1,1)*PDu(1) + FTSi1(2,1)*PDu(2));
        dy = (FTSi1(2,1)*PDu(1) + FTSi1(2,2)*PDu(2));
        
        if (abs(dx) > moMax1)
            si = sign(dx);
            dx = si*moMax1; 
        end
            
        if (abs(dy) > moMax1) 
            si = sign(dy);
            dy = si*moMax1; 
        end
        
        PosSnew(i,1) = PosSold1(i,1) + dt1*dx + dt1*VS1*c; % New x pos.  
        PosSnew(i,7) = dt1*dx + dt1*VS1*c;
        PosSnew(i,2) = PosSold1(i,2) + dt1*dy + dt1*VS1*s; % New Y pos.
        PosSnew(i,8) = dt1*dy + dt1*VS1*s;
        
        % Check the y boundary. Stopping boundary condition.       
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
        
        % kicks from the wall
        if kickMethod1 == 1
        
            if( PosSnew(i,2) >= Ysi1/2 - SWT1 ) % Top wall.       
                % Get the prob of a kick as a poisson process.
                if kickType1 == 'p'
                    p = k1;
                else
                    p = 1 - exp(-k1*dt1);
                end
                if( rand(stream) <= p ) 
                    % get the kick angle.
                    if polarity1 == +1
                         phi2 = pi*normrnd(3/8, 1/9);
                    else 
                         phi2 = pi*normrnd(pi+3/8, 1/9);
                    end
                    % get the sign of the x displacement to get the sign of
                    % kick angle.
                    if( PosSnew(i,1) - PosSold1(i,1) > 0 )                   
                        PosSnew(i,3) = atan2(-sin(phi2), cos(phi2));                 
                    else                    
                        PosSnew(i,3) = atan2(-sin(phi2), -cos(phi2));                    
                    end                    
                end           
            elseif ( PosSnew(i,2) <= -Ysi1/2 + SWT1 ) % Bottom wall.        
                % Get the prob of a kick as a poisson process.
                if kickType1 == 'p'
                    p = k1;
                else
                    p = 1 - exp(-k1*dt1);
                end
                if( rand(stream) <= p ) 
                    % get the kick angle.
                    if polarity1 == +1
                         phi2 = pi*normrnd(3/8, 1/9);  
                    else 
                         phi2 = pi*normrnd(pi+3/8, 1/9); 
                    end               
                    % get the sign of the x displacement to get the sign of
                    % kick angle.
                    if( PosSnew(i,1) - PosSold1(i,1) > 0 )                   
                        PosSnew(i,3) = atan2(sin(phi2), cos(phi2));                 
                    else                    
                        PosSnew(i,3) = atan2(sin(phi2), -cos(phi2));                    
                    end                
                end        
            end % end of kick calculations.
            
        else
            
            % Probability of a kick check.
            p = 1-exp(-k1*dt1); % poisson probability.
            event = max(abs(PosSold1(i,5)),sign(p - rand(stream)));
            
            % Check the particle is in the right place to continue/start an
            % event.
            s1 = (sign( PosSnew(i,2) - (Ysi1/2 - SWT1) )  + 1)/2; % above the threshold.
            s2 = (sign( PosSnew(i,2) + (Ysi1/2 - SWT1) )  - 1)/2; % check if it's below.
            PosSnew(i,9) = event*(s1 + s2); % get the signed outcoome, multiply by the event check.
        
        end
        
        PosSnew(i,4) = PosSold1(i,4);
        
        % Boundary in x.
        while PosSnew(i,1) < -Xsi1/2
            PosSnew(i,1) = PosSnew(i,1) + Xsi1;
        end
        while PosSnew(i,1) > Xsi1/2
            PosSnew(i,1) = PosSnew(i,1) - Xsi1;
        end
        
    end

end % End.

