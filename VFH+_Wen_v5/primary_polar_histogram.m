% this function's input is lidar distance(720);
% than process this array of enlarged robot radius and safe disyance
% the method I use is firstly subtract robot radius and safe distance
% directly, than recorrect it because some close obstacles were enlarged.

% run this function as
% [Hp_k,binary_histgram]=primary_polar_histogram(lidar1,theta_unit);
function [Hp_k,binary_histgram]=primary_polar_histogram(lidar1,theta_unit)
% lidar degree resolution we choose is 6, so there will be 45 sections and
% each section has 16 lidar data.
robot_r=0.5;
ds=0.5;
lidar2=lidar1-(robot_r+ds);
%theta_unit=lidar.LatestMessage.AngleIncrement;
for i=2:length(lidar1)
    if lidar1(i)-lidar1(i-1)>0.8   % later greater than former one
        gamma=atan(robot_r/lidar1(i-1));
        beta=floor(gamma/theta_unit);
        short_side=(lidar1(i-1)^2-1^2)^0.5;
        lidar2(i-1:i+beta-2)=linspace(lidar1(i-1)-1,short_side,beta);% right
        
        % correctly
    elseif lidar1(i-1)-lidar1(i)>0.5   % former greater than former one
        gamma=atan(robot_r/lidar1(i));
        beta=floor(gamma/theta_unit);
        short_side=(lidar1(i)^2-1^2)^0.5;
        if i>beta
           lidar2(i:-1:i-beta+1)=linspace(lidar1(i)-1,short_side,beta); 
        else
            lidar2(i:-1:1)=linspace(lidar1(i)-1,short_side,i);
        end 
        
    end
end
   Hp_k=lidar2(1:720);
   binary_histgram=Hp_k<2;
  % subplot 211
  % when you finish running this function, run following function.
  figure 
  stem((lidar.LatestMessage.AngleMin:lidar.LatestMessage.AngleIncrement:lidar.LatestMessage.AngleMax),lidar1);
  % subplot 212
  figure
  stem((lidar.LatestMessage.AngleMin:lidar.LatestMessage.AngleIncrement:lidar.LatestMessage.AngleMax),Hp_k);
  figure
  stem((lidar.LatestMessage.AngleMin:lidar.LatestMessage.AngleIncrement:lidar.LatestMessage.AngleMax),binary_histgram); 
end
  
