function smooth_array=calc_smooth_6(section_avg_array,L)
% In this function, the following equation is used:
%
%          hh(k-L)+2*hh(k-L+1)+...+L*hh(k)+...+2*hh(k+L-1)+hh(k+L)
% H(k) =  ---------------------------------------------------------
%                               2*L + 1
% L should be odd
%     max_sectors = length(section_avg_array); % variable for visual comprehension
%     new_ms=[zeros(1,L),section_avg_array,zeros(1,L)];
%     smooth_array=zeros(1,max_sectors);
%     
%     ratio = [(1:1:L),L,(L:-1:1)];            % for example if L=3, The ratio sequence
%                                              % of the numerator should be: 
%                                              % 1 2 3 3 3 2 1
%     H_temp = conv(h,ratio);
%     smooth_array(1:max_sectors)=H_temp(L+1:L+max_sectors)/(2*L+1);
% end
%     
    mex mexExamTemp.c;
    H=section_avg_array;
    mexExamTemp(H,L);
end