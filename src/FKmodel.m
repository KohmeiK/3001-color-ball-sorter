function [FK] = FKmodel(T1, T2, T3)
    FK = XYZ(T1, T2, T3);
    P = XYZPlot(FK);
    axs = axis;
    view(3);
    daspect([1 1 1]);
    h = triad('Parent',axs,'Scale',5,'LineWidth',3,...
          'Tag','Triad Example','Matrix',...
          makehgtform('xrotate',pi/4,'zrotate',pi/3,'translate',[1,2,3]));
    
    
    plot3(P(1,:),P(2,:),P(3,:),'-o','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF');
    grid on;%axis([-31,31,-31,31,0,31]);
    title('Forward Kinematics Stick Model')
    xlabel('X Axis');
    ylabel('Y Axis');
    zlabel('Z Axis');
    axis([-200 200 -200 200 0 400]);
end