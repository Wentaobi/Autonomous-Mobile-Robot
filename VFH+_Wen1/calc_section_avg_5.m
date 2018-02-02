% in this function, I selestion a array_resolution(I think it equals to lidar_resolution)
% then I calculate how many sections in each array_resolution, the purpose
% I use average in each section is used to select which section for our
% robot to go.
function section_avg_array=calc_section_avg_5(obstacles_array,array_resolution)
sections=length(obstacles_array)/array_resolution;
space=array_resolution-1;
section_avg_array=zeros(1,sections);
for i=1:sections
    start=(i-1)*array_resolution+1;
    section_avg_array(i)=sum(obstacles_array(start:i*array_resolution))/array_resolution;
end
end
    
    
