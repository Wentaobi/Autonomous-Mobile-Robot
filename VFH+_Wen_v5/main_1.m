% this is main programming, include ros-gazebo set-up, parameters
% initialize, and main loop. the process about main loop is listed as
% follows.
% 1st: calculate target in which section in reference to the lidar's view
% 2nd: calculate lidar's view data; give every angel a dangerous value according to their lidar distance
% 3rd: calculate long obstacles array to section by section.
% 4th: calculate every section's average
% 5th: convert average array to smooth array
% 6th: set a threshold to convert smooth array to binary array
% 7th: get valley where are 0s
% 8th: choose which valley you go
% 9th: adjust heading
% 10th: calcaulate find angular and linear volocity 
clear;
clc;
close all;
rosshutdown;
master_ipaddress='192.168.12.42';
host_ipaddress='192.168.12.42';
rosinit(master_ipaddress,'NodeHost',host_ipaddress);
% global values and main-sub function
% Lidar angle data
lidar=rossubscriber('/scan');
lidarMsg=lidar.LatestMessage;

robot=rospublisher('/cmd_vel');% control 
% Lidar position data
odom=rossubscriber('/odometry/filtered');
odomdata = receive(odom,3);
odomdata = odom.LatestMessage;
%velmsg.Linear.X = 0;% 0;
%velmsg.Angular.Z = 0;% 0
%% global 
robot_radus=0.5;
target_position=[-5,5];
lidar_resolution=8;
%%
%for i=1:100000
lidarMsg=lidar.LatestMessage;    
lidar_Ranges = lidarMsg.Ranges;
theta_unit=lidar.LatestMessage.AngleIncrement;
lidar1=lidar_Ranges;
odomdata = odom.LatestMessage;
pose = odomdata.Pose.Pose;
x = pose.Position.X;
y = pose.Position.Y;
z = pose.Position.Z;
quat = pose.Orientation;
angles = quat2eul([quat.W quat.X quat.Y quat.Z]);
theta = rad2deg(angles(1));
%pause(0.02);
%% sub function
%scan_sub = rossubscriber('/scan',@scan_plot);
current_position=[x,y];
  if theta<0
        theta = theta + 360;
  end
current_head=theta;
target_sector=calc_target_3(target_position,current_position,current_head);
maxdistance=8;
mindistance=0;
%distance_resolution=3;
obstacles_array=calc_lidardata_4(lidar1,maxdistance);
array_resolution=8;
section_avg_array=calc_section_avg_5(obstacles_array,array_resolution);
smooth_array=calc_smooth_6(section_avg_array,3);
high_threshold=1;
binary_polar_histogram=calc_two_thresholds_7(smooth_array,high_threshold);
[valley_position_array]=get_valley_8(binary_polar_histogram);
select_valley=pick_valley_9(valley_position_array,target_sector);
choose_heading=select_direction_10(select_valley,target_sector);
v_max=3;
w_max=1;
[v,w]=calc_final_speed_11(choose_heading,smooth_array,v_max,w_max);
%%
%for pp=1:600
velmsg=rosmessage(robot);
velmsg.Linear.X = v;%  
velmsg.Angular.Z = w;%  
send(robot,velmsg);
%pause(0.1);
%end
distance=sqrt((target_position(2)-current_position(2))^2+(target_position(1)-current_position(1))^2);
if distance<1 
    rosshutdown;% get target, game over
    disp('haha! dude! you got it!')
    break;
end
end