function c_ang=cycle_ang(ang)

if ang<360
    if ang>=0;
        c_ang=ang;
    else
        c_ang=360+ang;
    end
else
    c_ang=ang-360;
end