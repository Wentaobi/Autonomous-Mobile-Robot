% in this function, when you have current head and target head and which angel to go,
% I will calculate the suitable linear and angulay volocity you should set
% according to paper.then this two parameters will send to ROS-Gazebo.
function [v,w]=calc_final_speed_11(current_head,current_heading,smooth_array,w_max,v_max,lidar_resolution)
if current_head>225
    current_headx=225;
else
    current_headx=current_head;
end
hcp=smooth_array(round((current_headx+45)/lidar_resolution));
hm=18;
hcpp=min([hcp,hm]);
v=v_max*(1-(hcpp/hm));
omeg_max=70;
w=w_max*(abs(current_head-current_heading))/omeg_max;
v=v*(1-(w/70))+0.1;
if v<0
    v=0.1;
end
end