 %% 

% Initialize ROS 
rosshutdown
clear;
clc;
close all;
master_ipaddress='192.168.12.42';
host_ipaddress='192.168.12.42';
rosinit(master_ipaddress,'NodeHost',host_ipaddress);

% Subscribe to Lidar and Odometry
% Publish to Velocity
lidar=rossubscriber('/scan');
odom=rossubscriber('/odometry/filtered');
robot=rospublisher('/cmd_vel');

%%

% Define global variables agreed upon by our groups
Wmax = 3; %max angular velocity
Vmax = 1; %max forward velocity
robotDim = .6; %robot width (m)
threshold = 1; %threshold (m)
sectorSize = 8; %8 lidar sectors per calculation sector
maxRange = 8; %max range in meters
valleyMin = 20; %minimum sectors for a wide valley

% Initialize all data that will be plotted
h=zeros(1,90);
hp=zeros(1,90);
hb=zeros(1,90);
where = 0;
heading = 0;
vel = 0;
angvel = 0;
current = [0 0];
% Update target and "evaluate" target and distance to chose a new heading
target = [5 5];
distance = 999;

% %% - PLOT INITIALIZATION
% 
% % A self-updating plot of all important data
VFH_fig = figure(1);
set(VFH_fig,'Position',[50,50,600,650]);
xp=1:90;
% 
% Plots the initial h graph
subplot(4,1,2)
s=plot(xp,h,'YDataSource','h');
axis([1 90 0 8]);
title('h - Danger Detection Input');
text(0,18,'\bfX-POS: ','Color','red','FontSize',12,'BackgroundColor','white');
text(0,16,'\bfY-POS: ','Color','green','FontSize',12,'BackgroundColor','white');
text(0,14,'\bfFWD-VEL: ','Color','blue','FontSize',12,'BackgroundColor','white');
text(0,12,'\bfANG-VEL: ','Color','black','FontSize',12,'BackgroundColor','white');

t1=text(20,18,num2str(current(1)),'Color','red','FontSize',12,'BackgroundColor','white');
t2=text(20,16,num2str(current(2)),'Color','green','FontSize',12,'BackgroundColor','white');
t3=text(20,14,num2str(vel),'Color','blue','FontSize',12,'BackgroundColor','white');
t4=text(20,12,num2str(angvel),'Color','black','FontSize',12,'BackgroundColor','white');

h1=text(heading-1,.7,int2str(heading),'Color','red','FontSize',12);
h2=text(where-1,.2,int2str(where),'Color','blue','FontSize',12,'BackgroundColor','white');

% Plots initial hp graph - smoothed curve    
subplot(4,1,3)
u=plot(xp,hp,'YDataSource','hp');
title('hp - Averaged Lidar Reading');

% Plots initial hb - threshold graph
subplot(4,1,4)
t=stem(xp,hb,'YDataSource','hb');
title('hb - Data through threshold');
h1=text(heading-1,.7,int2str(heading),'Color','red','FontSize',12);
h2=text(where-1,.2,int2str(where),'Color','blue','FontSize',12,'BackgroundColor','white');

%% 

while distance > 1.5
    tic
    
    lidarMsg = lidar.LatestMessage;
    lidarRanges = lidarMsg.Ranges;

    odomdata = odom.LatestMessage;
    pose = odomdata.Pose.Pose;
    x = pose.Position.X;
    y = pose.Position.Y;
    z = pose.Position.Z;
    
    quat = pose.Orientation;
    angles = quat2eul([quat.W quat.X quat.Y quat.Z]);
    theta = rad2deg(angles(1));
    % Changes theta from a (-180 - 180) to a (0 - 360) for calc_Target
    if theta<0
        theta = theta + 360;
    end

    % Update current position from odometer
    current = [x, y];
    currHeading = theta;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                           VFH ALGORITHM                          %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    m = calcDanger(lidarRanges, maxRange);
    h = calc_h(m, sectorSize);
    hp = Calc_hp(h,3);
    hb = calc_Hb(hp, threshold);
    [valleys,sectToclear] = find_Valleys(hb, threshold, robotDim);
    heading = calc_Target(target,current,currHeading);
    valley = pickValley(valleys, heading);
    where = pick_Heading(heading,valley,valleyMin,sectToclear);
    [vel, angvel] = determine_velocity(where,hp,Wmax,Vmax);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Publish calculated forward and angular velocity to Husky
    velmsg=rosmessage(robot);
    velmsg.Linear.X = vel;
    velmsg.Angular.Z =angvel;
    send(robot,velmsg);
    
    % Calculate distance for loop checking (see if target is reached)
    distx = target(1) - current(1);
    disty = target(2) - current(2);
    dist = sqrt(distx^2 + disty^2);
    distance = dist;
    
%     % Update plots!
    subplot(4,1,2)
    refreshdata(s,'caller');
    delete(t1); 
    delete(t2); 
    delete(t3); 
    delete(t4);
    t1=text(20,18,num2str(current(1)),'Color','red','FontSize',12,'BackgroundColor','white');
    t2=text(20,16,num2str(current(2)),'Color','green','FontSize',12,'BackgroundColor','white');
    t3=text(20,14,num2str(vel),'Color','blue','FontSize',12,'BackgroundColor','white');
    t4=text(20,12,num2str(angvel),'Color','black','FontSize',12,'BackgroundColor','white');
    drawnow;
    
    subplot(4,1,3)
    refreshdata(u,'caller');
    drawnow;
    
    subplot(4,1,4)
    delete(h1);
    delete(h2);
    hb=double(hb);
    refreshdata(t,'caller');
    h1=text(heading-1,.7,int2str(heading),'Color','red','FontSize',12,'BackgroundColor','white');
    h2=text(where-1,.2,int2str(where),'Color','blue','FontSize',12,'BackgroundColor','white');
    drawnow;
    
    toc
end





