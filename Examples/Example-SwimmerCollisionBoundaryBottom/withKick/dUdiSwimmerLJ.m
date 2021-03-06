% Function that calculates the gradient of the potential using a yakawa
% potential to treat the swimmers/colloids as hard spheres.

function [DuDiS1] = dUdiSwimmerLJ(posSold1,posCold1,SDV1,RS1,RC1,Ns1,Nc1,eps1,wall1)

    sigSC = zeros(3,1); % Initialise interaction length array for swimmer/colloid interactions.
    sigSW = zeros(3,1); % Initialise interaction length array for swimmer/wall interactions.  
    sigSS = zeros(3,3); % Initialise interaction length array for swimmer/swimmer interactions.
    DuDiS1 = zeros(Ns1,3); % Initialise output array for the gradients.
    
    % set the s/c and s/w interaction lengths as sum of their radii.
    for i = 1:3
        sigSC(i) = (RS1(i) + RC1)/2^(1/6); % Comment out to turns off backforce.
        sigSW(i) = (RS1(i))/2^(1/6);
    end
    
    % set the s/s interaction lengths as sum of their radii.
    for i = 1:3
       for j = 1:3
          sigSS(i,j) = (RS1(i) + RS1(j))/2^(1/6); 
       end
    end
    
    % main loop.    
    for sw1 = 1:Ns1 % Interactions occur on sw1.
        for seg1 = 1:3 % Summing segments of sw1.
            
            % Get all swimmers excluding sw1.
            sw2R = find(1:Ns1~=sw1);
            
            % Get swimmer orientation.
            co = cos(posSold1(sw1,3));
            si = sin(posSold1(sw1,3));
            
            % Swimmer-swimmer loop.
            for sw2 = sw2R % Int. from swimmer sw2.         
                for seg2 = 1:3 % sw2 segment.
                   
                    % Get coords of seg. of 1: r1, and seg. of 2: r2.
                    r1 = [posSold1(sw1,1) + SDV1(seg1)*co, posSold1(sw1,2) + SDV1(seg1)*si];
                    r2 = [posSold1(sw2,1) + SDV1(seg2)*co, posSold1(sw2,2) + SDV1(seg2)*si];           
                    
                    % Get distance and inverse of for potentials.
                    dr = norm(r1-r2);
                    
                    if ( dr < 2^(1/6)*sigSS(seg1,seg2) )
                    
                        drm1 = 1/dr;
                        dx = (r1(:,1) - r2(:,1));
                        dy = (r1(:,2) - r2(:,2));

                        % Get the motions (simplifies calculation of gradients).
                        fx = -24*eps1*sigSS(seg1,seg2)^6*drm1^13*(dr^6-2*sigSS(seg1,seg2)^6) *dx*drm1;
                        fy = -24*eps1*sigSS(seg1,seg2)^6*drm1^13*(dr^6-2*sigSS(seg1,seg2)^6) *dy*drm1;
                        fth= 24*eps1*sigSS(seg1,seg2)^6*drm1^13*(dr^6-2*sigSS(seg1,seg2)^6) *SDV1(seg1)*(dy*co-dx*si);
                        %fth= 24*eps1*sigSS(seg1,seg2)^6*drm1^13*(dr^6-2*sigSS(seg1,seg2)^6) *abs(SDV1(seg1))*(dx*co1-dy*si1);

                        
                        % Get the gradients.
                        DuDiS1(sw1,1) = DuDiS1(sw1,1) + fx;
                        DuDiS1(sw1,2) = DuDiS1(sw1,2) + fy;
                        DuDiS1(sw1,3) = DuDiS1(sw1,3) + fth;
                    
                    end
                    
                end
            end

            % Swimmer-colloid loop.
            for s = 1:Nc1 % Int. from colloid s.

                    % Get coords of seg. of 1: r1, and seg. of 2: r2.
                    r1 = [posSold1(sw1,1) + SDV1(seg1)*cos(posSold1(sw1,3)), posSold1(sw1,2) + SDV1(seg1)*sin(posSold1(sw1,3))];
                    r2 = [posCold1(s,1), posCold1(s,2)];           
                    
                    % Get distance and inverse of for potentials.
                    dr = norm(r1-r2);
                    
                    if ( dr < 2^(1/6)*sigSC(seg1) )
                    
                        drm1 = 1/dr;
                        dx = (r1(:,1) - r2(:,1));
                        dy = (r1(:,2) - r2(:,2));

                        % Get the motions (simplifies calculation of gradients).
                        fx = -24*eps1*sigSC(seg1)^6*drm1^13*(dr^6-2*sigSC(seg1)^6) *dx*drm1;
                        fy = -24*eps1*sigSC(seg1)^6*drm1^13*(dr^6-2*sigSC(seg1)^6) *dy*drm1;
                        fth= 24*eps1*sigSC(seg1)^6*drm1^13*(dr^6-2*sigSC(seg1)^6) *SDV1(seg1)*(dy*co-dx*si);
                        %fth= -24*eps1*sigSC(seg1)^6*drm1^13*(dr^6-2*sigSC(seg1)^6) *SDV1(seg1)*(dx*co-dy*si);


                        % Get the gradients.
                        DuDiS1(sw1,1) = DuDiS1(sw1,1) + fx;
                        DuDiS1(sw1,2) = DuDiS1(sw1,2) + fy;
                        DuDiS1(sw1,3) = DuDiS1(sw1,3) + fth;
                    
                    end
                    
            end

            % Swimmer-wall loop.            
            for side = 1:2

                % Get coords of seg. of 1: r1, and seg. of 2: r2.
                y1 = posSold1(sw1,2) + SDV1(seg1)*sin(posSold1(sw1,3));
                y2 = wall1(side);           

                siW = sign(y2);

                % Get distance and inverse of for potentials.
                dr = siW*(y1 - y2);
                
                if ( abs(dr) < 2^(1/6)*sigSW(seg1) )
                
                    drm1 = 1/dr;
                    dy = (y1 - y2);

                    % Get the motions (simplifies calculation of gradients).
                    fy = -24*eps1*sigSW(seg1)^6*drm1^13*(dr^6-2*sigSW(seg1)^6) *dy*drm1;
                    fth= -24*eps1*sigSW(seg1)^6*drm1^13*(dr^6-2*sigSW(seg1)^6) *SDV1(seg1)*(dy*co);

                    % Get the gradients.
                    DuDiS1(sw1,2) = DuDiS1(sw1,2) + fy;
                    DuDiS1(sw1,3) = DuDiS1(sw1,3) + fth;
                
                end

            end
        end        
    end    
end
