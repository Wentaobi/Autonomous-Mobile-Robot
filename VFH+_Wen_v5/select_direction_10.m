% in this funtion, after you choose which way to go, the tobot will chnage
% the angular to target, so I calculate the how many angel you need to
% turn.
function choose_heading=select_direction_10(select_valley,target_sector)
%kk=lidar_resolution*270/720;
%choose_heading=(round(mean(select_valley)))*lidar_resolution;
%current_heading(2)=select_valley(round(length(select_valley)/2))*lidar_resolution;
sectToClear=10;
buffer=ceil(sectToClear/2)+1; %Buffer so robot does not hug walls to close

wideValleyMin=20;
%Check to see if the chosen valley is wide or narrow
if diff(select_valley)<=wideValleyMin
    choose_heading=round(mean(select_valley));
else
    select_valley(1)=select_valley(1)+buffer;
    select_valley(2)=select_valley(2)-buffer;
    
    %Direct the Robot towards the portion of the valley that gets it most
    %in line with the target while still avoiding obstacles.
    if target_sector<select_valley(1)
        choose_heading=select_valley(1);
    elseif target_sector>select_valley(2);
        choose_heading=select_valley(2);
    elseif target_sector>=select_valley(1) && target_sector<=select_valley(2)
        choose_heading=target_sector;
    end
end
end