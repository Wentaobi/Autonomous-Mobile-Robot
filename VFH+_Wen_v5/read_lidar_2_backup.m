function lidar = read_lidar_2()
% Function 2
% This function acts as a test for the other functions to generate a lidar
%   reading. which connects ROS Gazebo and Matlab VFH Algrithem
%
% Inputs: Gazebo
%
% Outputs: 
%   lidar - Distances of obstacles from robot 
%  ROS Gazebo network connection
setenv('ROS_MASTER_URI','http://192.168.106.128:11311');% ros_ip
setenv('ROS_IP','172.18.62.138');% matlab_ip
% ros/matlab_ip
rosinit('192.168.106.128','NodeHost','172.18.62.138');
disp('ROS initialize succeed!');
rostopic list
% Lidar angle data
lidar=rossubscriber('/scan');
lidarMsg=lidar.LatestMessage;
lidar_Ranges = lidarMsg.Ranges;
max_LidarAng=lidarMsg.AngleMax;
min_LidarAng=lidarMsg.AngelMin;
% Lidar position data
odom=rossubscriber('/odometry/filtered');
odomdata = odom.LatestMessage;
pose = odomdata.Pose.Pose;
x = pose.Position.X;
y = pose.Position.Y;
z = pose.Position.Z;
quat = pose.Orientation;
angles = quat2eul([quat.W quat.X quat.Y quat.Z]);
theta = rad2deg(angles(1))
disp([x y z theta])
% Lidar volocity data
robot=rospublisher('/cmd_vel');% control 
velmsg=rosmessage(robot);
velmsg.Linear.X = 0.0;% v;
velmsg.Angular.Z =0.0;% w
send(robot,velmsg);
end


