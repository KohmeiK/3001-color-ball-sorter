function [bigMatrix] = XYZ(th1, th2, th3)
    T12 = matrix(th1, 95, 0, -90);
    T23 = matrix(th2-90, 0, 100, 0);
    T34 = matrix(th3+90, 0, 100, 0);
    
    T13 = T12*T23;
    T14 = T12*T23*T34;
    
    bigMatrix = [T12 T13 T14];
    
end