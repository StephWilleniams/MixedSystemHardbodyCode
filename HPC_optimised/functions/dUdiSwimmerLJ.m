% Function that calculates the gradient of the potential using a yakawa
% potential to treat the swimmers/colloids as hard spheres.

function [DuDiS1] = dUdiSwimmerLJ(posSold1,posCold1,SDV1,RS1,RC1,Ns1,Nc1,eps1,wall1,sigSW1,sigSC1,sigSS1)

    DuDiS1 = zeros(Ns1,3); % Initialise output array for the gradients.
    
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
                    
                    if ( dr < 2^(1/6)*sigSS1(seg1,seg2) )
                    
                        drm1 = 1/dr;
                        dx = (r1(:,1) - r2(:,1));
                        dy = (r1(:,2) - r2(:,2));

                        % Get the motions (simplifies calculation of gradients).
                        fx = -24*eps1*sigSS1(seg1,seg2)^6*drm1^13*(dr^6-2*sigSS1(seg1,seg2)^6) *dx*drm1;
                        fy = -24*eps1*sigSS1(seg1,seg2)^6*drm1^13*(dr^6-2*sigSS1(seg1,seg2)^6) *dy*drm1;
                        fth= 24*eps1*sigSS1(seg1,seg2)^6*drm1^13*(dr^6-2*sigSS1(seg1,seg2)^6) *SDV1(seg1)*(dy*co-dx*si);
                        %fth= 24*eps1*sigSS(seg1,seg2)^6*drm1^13*(dr^6-2*sigSS(seg1,seg2)^6) *abs(SDV1(seg1))*(dx*co1-dy*si1);

                        
                        % Get the gradients.
                        DuDiS1(sw1,1) = DuDiS1(sw1,1) + fx;
                        DuDiS1(sw1,2) = DuDiS1(sw1,2) + fy;
                        DuDiS1(sw1,3) = DuDiS1(sw1,3) + fth;
                    
                    end
                    
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
                
                if ( abs(dr) < 2^(1/6)*sigSW1(seg1) )
                
                    drm1 = 1/dr;
                    dy = (y1 - y2);

                    % Get the motions (simplifies calculation of gradients).
                    fy = -24*eps1*sigSW1(seg1)^6*drm1^13*(dr^6-2*sigSW1(seg1)^6) *dy*drm1;
                    fth= -24*eps1*sigSW1(seg1)^6*drm1^13*(dr^6-2*sigSW1(seg1)^6) *SDV1(seg1)*(dy*co);

                    % Get the gradients.
                    DuDiS1(sw1,2) = DuDiS1(sw1,2) + fy;
                    DuDiS1(sw1,3) = DuDiS1(sw1,3) + fth;
                
                end

            end
        end        
    end    
end
