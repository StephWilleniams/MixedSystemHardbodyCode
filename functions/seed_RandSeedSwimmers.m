% Function that initialises the swimmers in the system.
% To do this initally an array is created with the x, y position of the
% centre of the largest segment of the swimmer and the orientation measured to the
% horizontal of a line running from this centre of the largest segment to
% the smallest measured counter-clockwise.
% The x,y positions line in the square: [-Xsi/2,Xsi/2]x[-Ysi/2,Ysi/2].
% The positions are then checked pairwise to be at least 2 large segment
% radii apart.
% 4th coordinate keeps track of boundary crossings in the x direction.

% Testing parameters:
% Ns1 = 10;
% Nstep1 = 2;

function [PosS1,saverOn1] = seed_RandSeedSwimmers(Ns1, Nstep1, Xsi1, Ysi1, Rs3t2, saverSize1,stream)

    % Does the code need to use save features?
    saverOn1 = 0;
    if(saverSize1 < Nstep1)
        saverOn1 = 1;
    end
    
    if saverOn1 == 1
        % Array for all the positions of swimmers at each time step.
        PosS1 = zeros(Ns1, 5, saverSize1);
    else
        % Array for all the positions of swimmers at each time step.
        PosS1 = zeros(Ns1, 5, Nstep1);
    end   

%     % Array for all the positions of swimmers at each time step.
%     PosS1 = zeros(Ns1, 4, Nstep1);
    
    % Array of initial positions.
    Pos0 = zeros(Ns1,5); % Initialise array.
    Pos0(:,1) = (Xsi1-(2*Rs3t2))*(rand(stream,Ns1,1)-0.5); % Uniform dist. over x positions.
    Pos0(:,2) = (Ysi1-(2*Rs3t2))*(rand(stream,Ns1,1)-0.5); % Uniform dist. over y positions.
    
    % Loop to check the positions are non-overlapping.
    EscCond = 0; % Initalise escape condition.    
    while EscCond == 0
        EscCond = 1; % Set the escape condition to passing.
        % Loop over each coordinate pair.
        for i=1:Ns1
            for j=1:Ns1
                if i~=j               
                    % Check which sides of the swimmers are overlapping.
                    c1 = (Pos0(i,1) <= Pos0(j,1)+Rs3t2);
                    c2 = (Pos0(i,1) >= Pos0(j,1)-Rs3t2);
                    c3 = (Pos0(i,2) <= Pos0(j,2)+Rs3t2);
                    c4 = (Pos0(i,2) <= Pos0(j,2)-Rs3t2);                   
                    if ( c1 && c2 && c3 && c4 )
                        Pos0(i,1) = Xsi1*(rand(stream)-0.5); % Re-roll x position.
                        Pos0(i,2) = Ysi1*(rand(stream)-0.5); % Re-roll y position.
                        EscCond = 0; % modify escape condition due to failure, re-check required.
                    end % condition check.
                end % dirac detla IF loop.
            end % cell pair loop 2.
        end % cell pair loop 1.
    end % while loop,
    
    % Randomly distribute the oriantations.
    Pos0(:,3) = 2.*pi.*rand(stream,Ns1,1); 
    PosS1(:,:,1) = Pos0;

end

