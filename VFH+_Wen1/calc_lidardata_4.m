% in this function, when we have lidar data of each degree's distance,then
% I can make a certainity grid or certainity array to display all of
% obstacles according to lidar's view, if obstcles is very close,I set 3
% for this obstacle, then I set 2 for med-close obstacle, then I set 1 for
% some obstacles far, last I set 0 for distant obstacles because it is safe
% for our robot to go.so I called obstacles_array.
function obstacles_array=calc_lidardata_4(lidar1,maxangel,minangel,distance_resolution)
delta=(maxangel-minangel)/distance_resolution;
for i=1:length(lidar1)
    if minangel<=lidar1(i)&&lidar1(i)<=(minangel+delta)
        lidar1(i)=3;
    else if (minangel+delta)<lidar1(i)&&lidar1(i)<=(minangel+2*delta)
            lidar1(i)=2;
        else if (minangel+2*delta)<lidar1(i)&&lidar1(i)<=(minangel+3*delta)
                lidar1(i)=1;
                else if (minangel+3*delta)<lidar1(i)
                        lidar1(i)=0;
                    end
            end
        end
    end
end
obstacles_array=lidar1;