% this function, suppose you have target position[], current position[]
% and current head, you can calculate the angel between target-current position
% but your robot has head angel, so you should substract. at this moment,
% our lidar angel range is fro, -45~-135. so I add 45 to make it easier to
% operate and calculate.
function target_sector=calc_target_3(target_position,current_position,current_head)
theta1=(atan((target_position(2)-current_position(2))/(target_position(1)-current_position(1))))*180/pi-current_head;
dx= (target_position(1)-current_position(1));
dy=(target_position(2)-current_position(2));
if dx<0
    theta1=theta1+180;
end
target_sector=theta1+45;%?