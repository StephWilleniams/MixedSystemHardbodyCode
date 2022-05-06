%% Code to check the outputs

%% Plotter.

% Name the files
nFlag = 3;

% Make copies of the data and label them
copyfile('data',['data_' num2str(nFlag)])

% Load the data
load('data/C_1.mat')
load('data/S_1.mat')

% Set the runtime and the rate of making the images.
startval=1;
endval=floor(length(PosS1(1,1,:))/4);
fps = 1;

%
%RC = 0.25;
set_constants;
%
Ns = 1;
Nc = 1;

theta = 0:0.01:2*pi;

v = VideoWriter(['movies/mp4/sSHeadOnCol_' num2str(nFlag)],'MPEG-4');
v.FrameRate = 20;
open(v)

for i = startval:fps:endval
    
    hold off;
    
    for num = 1:Nc
        
        % Plot Colloid.
        plot(PosC1(num,1,i) + RC*sin(theta), PosC1(num,2,i) + RC*cos(theta),'color','k','lineWidth',3)
        set(gca,'ylim',[-5.1,5.1],'xlim',[-25.1,25.1])
        pbaspect([5 1 1])
        hold on;
        
    end
    
    for num = 1:Ns
        % Get colloid/swimmer coords.
        scatter(PosS1(num,1,i),PosS1(num,2,i));
        for seg = 1:3
            if PosS1(num,4,i) == 0
                plot(PosS1(num,1,i) + SDV(seg)*cos(PosS1(num,3,i)) + RS(seg)*sin(theta), PosS1(num,2,i) + SDV(seg)*sin(PosS1(num,3,i)) + RS(seg)*cos(theta),'color','g','lineWidth',3)
            else
                plot(PosS1(num,1,i) + SDV(seg)*cos(PosS1(num,3,i)) + RS(seg)*sin(theta), PosS1(num,2,i) + SDV(seg)*sin(PosS1(num,3,i)) + RS(seg)*cos(theta),'color','r','lineWidth',3)
            end
            set(gca,'ylim',[-4.1,4.1],'xlim',[-4.1,4.1])
            axis equal
            hold on;
        end
    end
    
    pause(0.1);
    
    saveas(gcf,['movies/png/' num2str(nFlag) '_' num2str(i) '.png']);
    A = imread(['movies/png/' num2str(nFlag) '_' num2str(i) '.png']);
    writeVideo(v,A)
    
end

copyfile('movies/png',['movies/png_' num2str(nFlag)])

close(v)


