%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Script.
% Code to simulate the dynamics of microswimmers interacting with colloids.
% Author: Stephen Williams
% Edits by:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Notes:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear Workspace;
clear figure;

%rmdir data s
mkdir data
mkdir movies/png
mkdir movies/mp4

addpath('../../functions/');

seedNum = 1;
stream = RandStream.create('mlfg6331_64','seed',seedNum);

% Set Boundary behaviours.
k = 0;
wTorq0 = -2*seedNum;

% Initialise.
set_constants; % Set all the constants from the constants script
kickType = 'np';
extension = '=k';

x0s = 0;
y0s = 4;
%theta0s = -pi/2+0.3; % Preset 1: Left facing
theta0s = -pi/2-0.3; % Preset 2: Right facing

x0c = 0;
y0c = 0;

%
fileNum = seedNum; 

%-------------------%
%%% INITIAL CONDITIONS
%-------------------%
% Seed system initial conditions.
%[PosS, saverOn] = seed_randSeedSwimmers(Ns,Nstep,Xsi,Ysi,2*RS(3),saverSize,stream); %#ok<ASGLU> % Uniform dist. swimmers and check non-overlapping.
[PosS] = seed_ArtifSeedSwimmers(Ns, Xsi, Ysi, RS, SBT, SDV, x0s, y0s, theta0s);
%[PosC, saverOn] = seed_randSeedColloids(Nc,Nstep,Xsi,Ysi,2*RC,saverSize,stream); % Uniform dist. colloids and check non-overlapping.
[PosC] = seed_ArtifSeedColloids(Nc, Xsi, Ysi, RC, x0c, y0c);
PosSold = zeros(Ns,5);
PosCold = zeros(Nc,4);
PosStemp = zeros(Ns,5);
PosCtemp = zeros(Nc,3);
PosSnew1 = zeros(Ns,9);
PosCnew1 = zeros(Nc,7);
PosSnew2 = zeros(Ns,8);
PosCnew2 = zeros(Nc,5);
%
drC = zeros(Nstep,2);
drS = zeros(Nstep,3);

store = zeros(Nstep-1,3);

%-------------------%
%%% MAIN LOOP
%-------------------%
for n = 1:Nstep-1 % loop over steps.
    
    % This set of loops is very inefficient.
    % Get the saver modified time.
    if saverOn == 1
        t = mod(n,saverSize)+1;
        if t ~= 1
            % Get the positions for the particles from the previous timestep.
            PosSold = PosS(:,:,t-1);
            PosCold = PosC(:,:,t-1);
        else
            % Get the positions for the particles from the temporary stored timestep.
            PosSold = PosStemp;
            PosCold = PosCtemp;
        end
    else
        t = n+1;
        % Get the positions for the particles from the previous timestep.
        PosSold = PosS(:,:,t-1);
        PosCold = PosC(:,:,t-1);
    end
    
    % Get the total translational friction and inverse for the swimmers.
    FTS = setFriction(FS, PosSold);
    FTSi = inv(FTS);    
    % Get the potential gradients.
    DuDiS = dUdiSwimmerLJ(PosSold,PosCold,SDV,RS,RC,Ns,Nc,epsilon,wall);
    DuDiC = dUdiColloidLJ(PosSold,PosCold,SDV,RS,RC,Ns,Nc,epsilon,wall);   
    store(n,:) = DuDiS;
    % Implement the swimmer and colloid move factoring for BC.
    % Note: generic moveswimmer? could be used here for both 1 and 2.
    PosSnew1(:,:) = moveSwimmer1(PosSold,DuDiS,Ns,FS,dt,DSr,FTSi,VS,SWT,Ysi,Xsi,k,RS,MoMax,kickType,SDV,SBT,polarity,kickMethod,wTorq0,stream);
    PosCnew1(:,:) = moveColloid1(PosCold,DuDiC,Nc,FC,dt,DC,mM,Ysi,Xsi,eps,0.1*MoMax,stream);
    
    % Get the total translational friction and inverse for the swimmers.
    FTS = setFriction(FS, PosSold);
    FTSi = inv(FTS);    
    % Get 2nd step potentials.
    DuDiS = dUdiSwimmerLJ(PosSnew1,PosCold,SDV,RS,RC,Ns,Nc,epsilon,wall);
    DuDiC = dUdiColloidLJ(PosSnew1,PosCold,SDV,RS,RC,Ns,Nc,epsilon,wall);    
    % Implement the swimmer and colloid move factoring for BC.
    % Note: generic moveswimmer? could be used here for both 1 and 2.
    PosSnew2(:,:) = moveSwimmer2(PosSnew1,DuDiS,Ns,FS,dt,DSr,FTSi,VS,SWT,Ysi,Xsi,k,RS,MoMax,kickType,SDV,SBT,polarity,kickMethod,wTorq0,stream);
    PosCnew2(:,:) = moveColloid2(PosCnew1,DuDiC,Nc,FC,dt,DC,mM,Ysi,Xsi,eps,0.1*MoMax,stream);
    
    % Combine the swimmer and colloid moves using RK2 and re-factor for BC.
    [PosS(:,:,t),drS(t,1),drS(t,2),drS(t,3)] = RK2swimmer(PosSold,PosSnew1,PosSnew2,dt,Ns,RS,Ysi,SWT,Xsi,k,kickType,SDV,SBT,polarity,kickMethod,stream);
    [PosC(:,:,t),drC(t,1),drC(t,2)] = RK2colloid(PosCold,PosCnew1,PosCnew2,Nc,Ysi,Xsi,eps,0.1*MoMax);
    
    % Save the data if it is needed.
    % Note: this step is horribly inefficient.
    if t == saverSize || n+1 == Nstep
        [PosS,PosC,PosStemp,PosCtemp] = dataSaver(PosS, PosC, t, seedNum);
    end
    
end

% Clear all large variables and save the workspace into the file with all the data.
% wrapUpRoutine; % Function to get rid of all large variables that are saved anyway.

