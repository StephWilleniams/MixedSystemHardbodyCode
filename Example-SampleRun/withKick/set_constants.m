% script containing all the constants used in the main script.

% CONSTANTS.
%%%
saverSize = 50000; % Number of timesteps stored at a time.
saverOn = 1;
%%%
% Dimensionalisation.
Lc = 10; % Characteristic length [um].
Vc = 100; % Characteristic velocity [um/s].
Tc = Lc/Vc; % Characteristic time [s].
%%%

% Simulation parameters dimensional.
T = 2; % Total code physical runtime [s].
dt = 0.0005; % Time increment[s].    
Xsi = 500; % Channel length [um].
Ysi = 100; % Channel width [um].
moMax = min(Ysi/2,Xsi/2);

% Simulation parameters non-dimensional (ND).
T = T/Tc; % Total code physical runtime.
dt = dt/Tc; % Time increment.
Nstep = round(T/dt); % Total steps in the simulation.
Xsi = Xsi/Lc; % Channel length.
Ysi = Ysi/Lc; % Channel width.
wall = zeros(2,1); % Initialise wall coordinates array.
wall(1) = Ysi/2; % Set top wall coordinate.
wall(2) = -Ysi/2; % Set botoom wall coordinate.
epsilon = 1; % Yakawa/LJ interaction potential strength. Note: should be in units of potential and non-dimensionalised.
MoMax = 0.01*moMax/(Lc*dt);

%%%
% Swimmers dimentional.
Ns = 25; % Number of swimmers.
if(Ns == 0) % Turn off warning for singular matrix inversion if no swimmers.
    warning('off','MATLAB:singularMatrix');
end
Rs = 15; % Swimmer size [um].
stype = 'o_new'; % Overlapping swimmmer.
%stype = 'o'; % Overlapping swimmmer (old).
%stype = 'no'; % Non-overlapping swimmer.
% Note: 1/(3 + sqrt(2)) = 0.2265409. % Non-overlapping hydrodynamic centre swimmer.
switch stype
    case 'o_new'
        RsMa = Rs / (2+1/sqrt(2));
    case 'o'
        RsMa = Rs / 3;
    case 'no'
        RsMa = Rs * 0.2265409;
end
Vs = -100; % Swimmer speed [um/s].
polarity = sign(Vs);
% something that works out Dsr from a desired correlation time for
% directions.
Dsr = 0.2;% Swimmer rotational diffusivity [rad^2/s].
%k = 0.1; % Kick frequency [Hz].
kickMethod = 0; % 1 for instant kicks, else for torque kicks.
%wTorq0 = -1; % Strength of kick torque.

% Swimmers non-dimensional.
RS = zeros(3,1); % Swimmer segment radii.
RS(3) = RsMa/Lc; % ND. swimmer largest segment radii.
RS(2) = RS(3)/sqrt(2); % Middle seg. ND radii.
RS(1) = RS(3)/2; % Smallest seg. ND radii.
VS = Vs/Vc; % ND. swimmer speed.
DSr = Dsr*Tc; % ND. Rotational diffusion.
SigSr = sqrt(2*DSr*dt); % ND Size of swimmer rotational diffusion.
AR = sum(RS)/(2*RS(3)); % Swimmer aspect ratio.
SDV = zeros(3,1); % Initalise segment displacement vectors.
switch stype
    case 'o_new'
        SDV(3) = (-Rs/(2*Lc) + RS(3)+ RS(2)); % Distance to largest seg. from HDC.
        SDV(2) = (-Rs/(2*Lc) + RS(3)); % Distance to middle seg. from HDC.
        SDV(1) = (-Rs/(2*Lc) + RS(3)/2); % Distance to small seg. from HDC.
    case 'o'
        delta = Rs/(6*Lc);
        SDV(3) = delta; % Distance to largest seg. from HDC.
        SDV(2) = delta - RS(3); % Distance to middle seg. from HDC.
        SDV(1) = delta - RS(3) - RS(2); % Distance to small seg. from HDC.
    case 'no'
        delta = RS(1) + RS(2); % Distance from swimmer hydrodynamic centre (HDC) to largest segment centre.
        SDV(3) = delta; % Distance to largest seg. from HDC.
        SDV(2) = delta - RS(3) - RS(2); % Distance to middle seg. from HDC.
        SDV(1) = delta - RS(3) - 2*RS(2) - RS(1); % Distance to small seg. from HDC.
end
SWt = RsMa; % Swimmer-wall kick interaction threshold distance [um].
SWT = 1.5*SWt/Lc; % ND swimmer-wall interaction threshold. 
SBT = 0.9; % stopping bdry for swimmers.
%%%
% Colloids dimensional.
Nc = 40; % Number of colloids.
Rc = 2.5; % Colloid Radius [um].
Dc = 0.2;% Colloid thermal diffusivity [um^2/s].
mm = 10;% Maximum move size thresh. for a colloid [um].
% Colloids non-dimensional.
RC = Rc/Lc; % ND Colloid Radius.
DC = Dc*Tc/(Lc^2); % ND Colloid diffusivity.
SigC = sqrt(2*Dc*dt); % ND Size of colloid diffusion motion.
mM = mm/Lc; % ND move size cap.
eps = -0.1; % Stopping boundary small position. Should allow Yukawa to move the colloid.
%%%
% Friction calculations (both via [1]).
f0 = 0.5; % Scaling factor for the friction forces.
FS = frictionCalculationSwimmer(f0,AR); % returns the Parallel, Perpendicular and (inverse) Rotational friction forces resp. for the swimmers.
FTS = zeros(2,2); % Store for swimmer translational friction to be later set by potential calculations.
FTSi = zeros(2,2); % Store for inverse of FTS.
FC = frictionCalculationColloid(f0); % Returns the colloid translational friction.
%%%
% Innitialise stores for potentials.
DuDiS = zeros(Ns,3);
DuDiC = zeros(Ns,2);
