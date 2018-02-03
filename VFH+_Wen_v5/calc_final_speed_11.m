% in this function, when you have current head and target head and which angel to go,
% I will calculate the suitable linear and angulay volocity you should set
% according to paper.then this two parameters will send to ROS-Gazebo.
 function [v,w]=calc_final_speed_11(choose_heading,smooth_array,v_max,w_max)
% if current_head>225
%     current_headx=225;
% else
%     current_headx=current_head;
% end
%%
hm=18;
hcp=min(max(smooth_array(30:60)),hm);

hcpp=min([hcp,hm]);
v=v_max*(1-(hcpp/hm));

omeg_max=15;
w=-(choose_heading-45)/3*w_max/omeg_max;
v=v*(1-abs(w/w_max));
%%
%  function [v,w]=calc_final_speed_11(choose_heading,target_sector)
% if target_sector>=choose_heading
%     w=0.5;
% else 
%     w=-0.5;
% end
% hm=18;
% hcp=min(max(smooth_array(30:60)),hm);
% 
% hcpp=min([hcp,hm]);
% v=v_max*(1-(hcpp/hm));
end