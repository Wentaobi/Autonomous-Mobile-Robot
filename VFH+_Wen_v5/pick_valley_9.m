% in this function, after you get a new array about valley, I will compare
% the target location in which valley,and choose this valley, if not, I
% will choose the closest valley. otherwise, no path to go.
function select_valley=pick_valley_9(valley_position_array,target_sector)
%valley_array=zeros(30,2);
          j=1;
  for i=1:length(valley_position_array)
      if length(valley_position_array{i})>=5
        valley_array(j,1)=min(valley_position_array{i});
        valley_array(j,2)=max(valley_position_array{i});
        j=j+1;
      end
  end
  dist = abs(valley_array-target_sector); 
  [r,c] = find(dist==min(dist(:)));
  select_valley = valley_array(r,:);

%The distance might be the same to two valleys, so we pick the larger one
if size(select_valley) > 1
    if select_valley(1) == select_valley(2)
        select_valley = unique(select_valley)';
        %If repeated valley, just take the unique value
    else
        larger = diff(select_valley');
        [r,t] = max(larger);
        select_valley = select_valley(t,:);
        %Picks the larger valley
    end
end
%function select_valley=pick_valley_9(binary_polar_histogram,valley_position_array,target_sector,lidar_resolution)
% x=1;
% closest=zeros(1,2*length(valley_position_array));
% target_section=round(target_sector/lidar_resolution);
% if (isempty(valley_position_array)==1)
%     disp('no path');
% else
%     for i=1:length(binary_polar_histogram)
%         if (length(valley_position_array{i})>=1)
%             if (target_section>=valley_position_array{i}(1)&&target_section<=valley_position_array{i}(end))
%                 select_valley=valley_position_array{i};
%                 break;
%             else
%                 closest(x)=abs(target_section-valley_position_array{i}(1));
%                 closest(x+1)=abs(target_section-valley_position_array{i}(end));
%                 x=x+2;
%                 if (i==length(valley_position_array))
%                     [value,position]=min(closest);
%                     select_valley=valley_position_array{round(position/2)};
%                     break;
%                 end
%             end
%         else
%             disp('no path');
%         end
%     end
% end
% function select_valley=pick_valley_9(valley_position_array,target_sector)
% dist = abs(valleyArs-T_heading); 
% [r,c] = find(dist==min(dist(:)));
% chosenValley = valleyArs(r,:);
% 
% %The distance might be the same to two valleys, so we pick the larger one
% if size(chosenValley) > 1
%     if chosenValley(1) == chosenValley(2)
%         chosenValley = unique(chosenValley)';
%         %If repeated valley, just take the unique value
%     else
%         larger = diff(chosenValley');
%         [r,t] = max(larger);
%         chosenValley = chosenValley(t,:);
%         %Picks the larger valley
%     end
% end
end
          