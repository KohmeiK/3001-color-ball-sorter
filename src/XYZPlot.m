function [P] = XYZPlot(FK)
    P1 = [0 FK(1,4) FK(1,8) FK(1,12)];
    P2 = [0 FK(2,4) FK(2,8) FK(2,12)];
    P3 = [0 FK(3,4) FK(3,8) FK(3,12)];
    
    P = [P1;P2;P3];
    
end