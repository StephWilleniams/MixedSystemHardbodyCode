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


function [PosC1] = seed_ArtifSeedColloids(Nc1, Xsi1, Ysi1, Rc,x1,y1)

    Nstep1 = 1;

    % Array for all the positions of swimmers at each time step.
    PosC1 = zeros(Nc1, 4, Nstep1);
    
    % Array of initial positions.
    Pos0 = zeros(Nc1,4); % Initialise array.
    Pos0(:,1) = 0; % Uniform dist. over x positions.
    
    for i = 1:Nc1
        Pos0(i,1) = x1;
        Pos0(i,2) = y1;
    end
    
%     % Loop to check the positions are non-overlapping.
%     EscCond = 0; % Initalise escape condition.    
%     while EscCond == 0
%         EscCond = 1; % Set the escape condition to passing.
%         % Loop over each coordinate pair.
%         for i=1:Ns1
%             for j=1:Ns1
%                 if i~=j               
%                     % Check which sides of the swimmers are overlapping.
%                     c1 = (Pos0(i,1) <= Pos0(j,1)+Rs3t2);
%                     c2 = (Pos0(i,1) >= Pos0(j,1)-Rs3t2);
%                     c3 = (Pos0(i,2) <= Pos0(j,2)+Rs3t2);
%                     c4 = (Pos0(i,2) <= Pos0(j,2)-Rs3t2);                   
%                     if ( c1 && c2 && c3 && c4 )
%                         Pos0(i,1) = Xsi1*(rand-0.5); % Re-roll x position.
%                         %Pos0(i,2) = Ysi1*(rand-0.5); % Re-roll y position.
%                         EscCond = 0; % modify escape condition due to failure, re-check required.
%                     end % condition check.
%                 end % dirac detla IF loop.
%             end % cell pair loop 2.
%         end % cell pair loop 1.
%     end % while loop,
    
    % Randomly distribute the oriantations.
    PosC1(:,:,1) = Pos0;

end