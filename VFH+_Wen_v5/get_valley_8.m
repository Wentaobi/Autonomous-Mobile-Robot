% in this function, after you got binary array, you have 0 and 1, a 0
% between two ones is valley, so I find how many valley and how many 0 in
% each valley
function [valley_position_array]=get_valley_8(binary_polar_histogram)
valley_position_array={};
valley=1;
start=1;
stop=0;
for index=1:length(binary_polar_histogram)
    if binary_polar_histogram(index)==0
        valley_position_array{valley}(start)=index;
        start=start+1;
        stop=1;
    elseif binary_polar_histogram(index)==1
        if stop==1
            valley=valley+1;
        end
        start=1;
        stop=0;
    end
end
% for i=1:length(valley_position_array)
%    if length(valley_position_array{i})>3
%        valley_position_array{i}=[];
%    end
% end
end
        
