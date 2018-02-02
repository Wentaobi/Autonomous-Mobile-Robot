% in this funtion, after you choose which way to go, the tobot will chnage
% the angular to target, so I calculate the how many angel you need to
% turn.
function current_heading=select_direction_10(select_valley,lidar_resolution)
current_heading=select_valley(round(length(select_valley))/2)*lidar_resolution;
end