% in this function, when we have lidar data of each degree's distance,then
% I can make a certainity grid or certainity array to display all of
% obstacles according to lidar's view, if obstcles is very close,I set 3
% for this obstacle, then I set 2 for med-close obstacle, then I set 1 for
% some obstacles far, last I set 0 for distant obstacles because it is safe
% for our robot to go.so I called obstacles_array.
%function obstacles_array=calc_lidardata_4(lidar1,maxdistance,mindistance,distance_resolution)
%delta=(maxdistance-mindistance)/distance_resolution;
function obstacles_array=calc_lidardata_4(lidar1)
d=lidar1; % Input of the Lidar readings
%a=maxdistance;
b=1;
%a=1+((ws-1)*0.5)^2;
a=8;
c=1;
% question : how to choose accurate a,b,c
for i = 1:length(d)
    %%
    % 
    %  PREFORMATTED
    %  TEXT
    % 
    if d(i) >= a
        m(i) = 0;
    else
        m(i)=c*c*(a-d(i)*b);%m(i)=c*c*(a-d(i)*d(i)*b);
    end
end
obstacles_array=m;
