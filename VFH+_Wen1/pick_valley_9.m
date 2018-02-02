% in this function, after you get a new array about valley, I will compare
% the target location in which valley,and choose this valley, if not, I
% will choose the closest valley. otherwise, no path to go.
function select_valley=pick_valley_9(binary_polar_histogram,valley_position_array,target_sector,lidar_resolution)
x=1;
closest=zeros(1,2*length(valley_position_array));
target_section=round(target_sector/lidar_resolution);
if (isempty(valley_position_array)==1)
    disp('no path');
else
    for i=1:length(binary_polar_histogram)
        if (length(valley_position_array{i})>=2)
            if (target_section>=valley_position_array{i}(1)&&target_section<=valley_position_array{i}(end))
                select_valley=valley_position_array{i};
                break;
            else
                closest(x)=abs(target_section-valley_position_array{i}(1));
                closest(x+1)=abs(target_section-valley_position_array{i}(end));
                x=x+2;
                if (i==length(valley_position_array))
                    [value,position]=min(closest);
                    select_valley=valley_position_array{round(position/2)};
                    break;
                end
            end
        else
            disp('no path');
        end
    end
end
end
          