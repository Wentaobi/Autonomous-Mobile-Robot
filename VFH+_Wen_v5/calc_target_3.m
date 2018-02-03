% this function, suppose you have target position[], current position[]
% and current head, you can calculate the angel between target-current position
% but your robot has head angel, so you should substract. at this moment,
% our lidar angel range is fro, -45~-135. so I add 45 to make it easier to
% operate and calculate.
function [target_sector,Th]=calc_target_3(target_position,current_position,current_head)
theta1=(atan(abs(target_position(2)-current_position(2))/(target_position(1)-current_position(1))))*180/pi;
deltax= (target_position(1)-current_position(1));
deltay=(target_position(2)-current_position(2));
% k_0=current_head-45;
% theta1=225-theta1;
% if deltax<0
%     theta1=theta1-180;
% end
% target_sector=theta1-current_head;%?
if deltax>0 && deltay>=0
    Th=current_head-theta1;
    if Th>180
        Th=Th-360;
    end
elseif deltax<0 && deltay>=0
    Th=current_head-(180-theta1);
    if Th>180
        Th=Th-360;
    end
elseif deltax<=0 && deltay<0
    Th=current_head-(180+theta1);
    if Th<-180
        Th=Th+360;
    end
elseif deltax>=0 && deltay<0
    Th=-(360-current_head-theta1);
    if Th<=-180
        Th=Th+360;
    end
end
%This loop makes sure the angle turn is within the scope of the Lidar
if Th<-135
    Th=-135;
elseif Th>135
    Th=135;
end

target_sector=round(((Th+135)*89/270)+1); %Return sector location of the Target in
                                 %relation to the robots heading.
end