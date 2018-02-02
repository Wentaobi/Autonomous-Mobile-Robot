% this is main function that we run all of sub-function and prosess data
% here. 
% setup ros-gazebo-matlab
rosshutdown
master_ipaddress='192.168.12.42';
host_ipaddress='192.168.12.42';
rosinit(master_ipaddress,'NodeHost',host_ipaddress);
% global values and main-sub function
% Lidar angle data
lidar=rossubscriber('/scan');
lidarMsg=receive(lidar,3);
lidarMsg=lidar.LatestMessage;
lidar_Ranges = lidarMsg.Ranges;
% Lidar position data
odom=rossubscriber('/odometry/filtered');
odomdata = receive(odom,3);
odomdata = odom.LatestMessage;

%% global 
robot_width=3;
target_position=[5,-5];
lidar_resolution=8;
lidar1=lidar_Ranges;
%%
for i=1:10000
pose = odomdata.Pose.Pose;
x = pose.Position.X;
y = pose.Position.Y;
z = pose.Position.Z;
quat = pose.Orientation;
angles = quat2eul([quat.W quat.X quat.Y quat.Z]);
theta = rad2deg(angles(1));
pause(0.02);
%% sub function

current_position=[x,y];
current_head=theta;
target_sector=calc_target_3(target_position,current_position,current_head);
maxangel=150;
minangel=10;
distance_resolution=7;
obstacles_array=calc_lidardata_4(lidar1,maxangel,minangel,distance_resolution);
array_resolution=8;
section_avg_array=calc_section_avg_5(obstacles_array,array_resolution);
smooth_array=calc_smooth_6(section_avg_array,3);
high_threshold=2;
binary_polar_histogram=calc_two_thresholds_7(smooth_array,high_threshold,low_threshold);
[valley_position_array]=get_valley_8(binary_polar_histogram);
select_valley=pick_valley_9(binary_polar_histogram,valley_position_array,target_sector,lidar_resolution);
current_heading=select_direction_10(select_valley,lidar_resolution);
w_max=30;
v_max=1.5;
[v,w]=calc_final_speed_11(current_head,current_heading,smooth_array,w_max,v_max,lidar_resolution);
%%
robot=rospublisher('/cmd_vel');% control 
velmsg=rosmessage(robot);
velmsg.Linear.X = v;% v;
velmsg.Angular.Z = w;% w
send(robot,velmsg);
distance=sqrt((target_position(2)-current_position(2))^2+(target_position(1)-current_position(1))^2);
if distance<2
    rosshutdown;% get target, game over
end
end