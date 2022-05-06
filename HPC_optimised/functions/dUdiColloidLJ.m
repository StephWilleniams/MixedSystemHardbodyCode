% Function that calculates the gradient of the potential using a yakawa
% potential to treat the swimmers/colloids as hard spheres.

function [DuDiC1] = dUdiColloidLJ(posSold1,posCold1,SDV1,RS1,RC1,Ns1,Nc1,eps1,wall1,sigCS1,sigCW1)

    sigCS = zeros(3,1); % Initialise interaction length array for swimmer/colloid interactions.
    DuDiC1 = zeros(Nc1,2); % Initialise output array for the gradients.
    
    % set the s/c interaction lengths as sum of their radii.
    for i = 1:3
        sigCS(i) = (RS1(i) + RC1)/2^(1/6);
    end
    
    % main loop.    
    for c1 = 1:Nc1 % Interactions occur on sw1.
        % Swimmer-colloid loop.
        for sw2 = 1:Ns1 % Int. from swimmer sw2.         
            for seg2 = 1:3 % sw2 segment.

                % Get coords of seg. of 1: r1, and seg. of 2: r2.
                r1 = [posCold1(c1,1), posCold1(c1,2)];
                r2 = [posSold1(sw2,1) + SDV1(seg2)*cos(posSold1(sw2,3)), posSold1(sw2,2) + SDV1(seg2)*sin(posSold1(sw2,3))];           

                % Get distances for potentials.
                dr = sqrt((r1(:,1) - r2(:,1))^2 + (r1(:,2) - r2(:,2))^2);
                
                if ( dr < 2^(1/6)*sigCS(seg2) )
                
                    drm1 = 1/dr;
                    dx = (r1(:,1) - r2(:,1));
                    dy = (r1(:,2) - r2(:,2));

                    % Get the potential (simplifies calculation of gradients).
                    fx = -24*eps1*sigCS(seg2)^6*drm1^13*(dr^6 - 2*sigCS(seg2)^6) *dx*drm1;
                    fy = -24*eps1*sigCS(seg2)^6*drm1^13*(dr^6 - 2*sigCS(seg2)^6) *dy*drm1;

                    % Get the gradients.
                    DuDiC1(c1,1) = DuDiC1(c1,1) + fx;
                    DuDiC1(c1,2) = DuDiC1(c1,2) + fy;
                
                end

            end
        end
        
        % Colloid-wall loop.
        for side = 1:2

            % Get coords of seg. of 1: r1, and seg. of 2: r2.
            y1 = posCold1(c1,2);
            y2 = wall1(side);  
            
            siW = sign(y2);

            % Get distance and inverse of for potentials.
            dr = siW*(y1 - y2);
            
            if ( abs(dr) < 2^(1/6)*sigCW )
               
                drm1 = 1/dr;
                dy = (y1 - y2);

                % Get the potential (simplifies calculation of gradients).
                fy = -24*eps1*sigCS(seg2)^6*drm1^13*(dr^6 - 2*sigCS(seg2)^6) *dy*drm1;

                % Get the gradients.
                DuDiC1(c1,2) = DuDiC1(c1,2) + fy;
            
            end

        end
        
    end

end
    

