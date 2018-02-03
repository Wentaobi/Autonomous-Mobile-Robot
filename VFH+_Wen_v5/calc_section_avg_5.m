% in this function, I selestion a array_resolution(I think it equals to lidar_resolution)
% then I calculate how many sections in each array_resolution, the purpose
% I use average in each section is used to select which section for our
% robot to go.
function sections=calc_section_avg_5(obstacles_array,array_resolution)
aifa=6;
n=270/aifa;
k=floor((theta+135)/aifa);
sections=length(obstacles_array)/array_resolution;
end 
    
    
