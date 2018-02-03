% in this function, after you got smooth obstacles array, now, it's time to
% find obstacles and empty space. according to paper, I set two thresholds
% to distinguish. the result is a binary array.(threshold+r_3)
function binary_polar_histogram=calc_two_thresholds_7(smooth_array,high_threshold)
for index=1:length(smooth_array)
    if smooth_array(index)>=high_threshold+1.0
        smooth_array(index)=1;
    else if smooth_array(index)<high_threshold+1.0
               smooth_array(index)=0;
        end
    end
    binary_polar_histogram=smooth_array;
%     binary_polar_histogram(1)=1;
%     binary_polar_histogram(90)=1; 
end