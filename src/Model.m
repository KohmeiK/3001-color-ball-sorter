classdef Model
    %MODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mainAxes
    end
    
    methods
        function obj = Model()
            %MODEL Construct an instance of this class
            %   Detailed explanation goes here
            obj.mainAxes = axes('Position',[0.1 0.1 0.8 0.8]);
            view(3);
        end
        
        function plotArm(obj,jointAngles)
            kine = Kinematics();
            %UNTITLED3 Summary of this function goes here
            jointAngles = deg2rad(jointAngles);
            T0to2 = kine.DHtoMatrix(jointAngles(1),95,0,-pi/2);
            T2to3 = kine.DHtoMatrix(jointAngles(2)-(pi/2), 0,100,0);
            T3to4 = kine.DHtoMatrix(jointAngles(3)+(pi/2),0,100,0);
            transforms = cat(3,T0to2, T2to3, T3to4);
            poses = zeros(4,4,size(transforms,3));
            for i = (1:size(transforms,3))
                if(i == 1) %For the first frame the pose is the transform
                    poses(:,:,i) = transforms(:,:,i);
                else %for everything else post muti with previous pose
                    poses(:,:,i) = poses(:,:,i-1) * transforms(:,:,i);
                end
            end
            %now all poses are ready
            
            cla %clear only data
            
            x = zeros(4,1);
            y = zeros(4,1);
            z = zeros(4,1);
            
            triad('Parent',obj.mainAxes,'Scale',30,'LineWidth',3);
            for i = (1:size(poses,3))
                triad('Parent',obj.mainAxes,'Scale',30,'LineWidth',3,'Matrix',poses(:,:,i));
                x(i+1) = poses(1,4,i);
                y(i+1) = poses(2,4,i);
                z(i+1) = poses(3,4,i);
            end
            
            plot3(x,y,z,'-o','LineWidth',4,'MarkerSize',10,'MarkerFaceColor',[0.5,0.5,0.5]);grid on;%axis([-31,31,-31,31,0,31]);
            % text(Q(1,5),Q(2,5),Q(3,5),['  (', num2str(Q(1,5),3), ', ', num2str(Q(2,5),3),', ', num2str(Q(3,5),3), ')']);
            title('3001 Virtual Arm')
            xlabel('X Axis');
            ylabel('Y Axis');
            zlabel('Z Axis');
            xlim([-220 220]);
            ylim([-220 220]);
            zlim([0 300]);
            drawnow
        end
    end
end

