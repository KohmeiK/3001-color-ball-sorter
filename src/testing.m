
function 
x = [0 2 5]
y = [0 2 -2]
z = [0 2 4]

figure
ax1 = axes('Position',[0.1 0.1 0.7 0.7]);
view(3);
triad('Parent',ax1,'Scale',1,'LineWidth',3,'Tag',"Description",...
'Matrix',makehgtform('translate',[1 1 1]));


plot3(x,y,z,'-o','LineWidth',2,'MarkerSize',6,'MarkerFaceColor',[0.5,0.5,0.5]);grid on;%axis([-31,31,-31,31,0,31]);
% text(Q(1,5),Q(2,5),Q(3,5),['  (', num2str(Q(1,5),3), ', ', num2str(Q(2,5),3),', ', num2str(Q(3,5),3), ')']);
title('3001 Virtual Arm')
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
xlim([-10 10]);
ylim([-10 10]);
zlim([0 10]);
% axis([-20 20 0 20 0 20]);
end