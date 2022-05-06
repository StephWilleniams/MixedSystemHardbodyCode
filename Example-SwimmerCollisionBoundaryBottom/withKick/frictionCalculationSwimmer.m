% Function that calculates the different frictional forces that act on the
% swimmers as they move through the liquid. These come from Lowen's paper
% on the friction on active rods [1]. The value returned by the function is
% the translational friction of the swimmer since this is the only value
% later used in the code.

function [FS] = frictionCalculationSwimmer(f01,AR1)

    FS = zeros(3,1); % Initialise the array of frictional forces.

    % Force calculations.
    fPaS = (2*pi)/(log(AR1)-0.207+(0.980/AR1)-(0.133/(AR1^2))); % Swimmer parallel frictional force.
    fPeS = (4*pi)/(log(AR1)+0.839+(0.185/AR1)+(0.233/(AR1^2))); % Swimmer perpendicular frictional force.
    fRoS = (pi*(AR1^2))/(3*(log(AR1)-0.662+(0.917/AR1)-(0.050/(AR1^2)))); % Swimmer rotational frictional force.
    
    % Rescale all the friction forces by the scale factor.
    fPaS = fPaS*f01;
    fPeS = fPeS*f01;
    fRoS = fRoS*f01;
    
    % Set the values of the output array.
    FS(1) = fPaS;
    FS(2) = fPeS;
    FS(3) = 1/fRoS; % Inverse is all that is ever used.

end

