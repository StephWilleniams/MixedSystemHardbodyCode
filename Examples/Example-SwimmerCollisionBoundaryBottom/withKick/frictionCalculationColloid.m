% Function that calculates the different frictional forces that act on the
% colloids as they move through the liquid. These come from Lowen's paper
% on the friction on active rods [1]. The value returned by the function is
% the inverse of the translational friction of the colloid since this is the only value
% later used in the code.

function [FC] = frictionCalculationColloid(f01)
    
    fPaC=(2*pi)/(-0.207+0.980-0.133); % Parallel colloid friction.
    fPeC=(4*pi)/(0.839+0.185+0.233); % Perpendicular colloid friction.
    fTC=f01*(fPeC); % Translational colloid friction.

    FC = 1/fTC;
    
end

