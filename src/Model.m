classdef Model
    %MODEL handles all calcuations and display of the ball and stick model
    
    properties
        mainAxes
    end
    
    methods
        function obj = Model()
            %MODEL Construct an instance of this class
            %Make axes window
            obj.mainAxes = axes('Position',[0.1 0.1 0.8 0.8]);
            view(3);
        end
        
        %Plotting the stick model
        function plotArm(obj,jointAngles)
            %Loop that updates the ball and stick model
            
            kine = Kinematics(95,100,100,[-90,90;-46,90;-86,63]);
            jointAngles = deg2rad(jointAngles);
            
            %Values from DH table
            T0to2 = kine.DHtoMatrix(jointAngles(1),95,0,-pi/2);
            T2to3 = kine.DHtoMatrix(jointAngles(2)-(pi/2), 0,100,0);
            T3to4 = kine.DHtoMatrix(jointAngles(3)+(pi/2),0,100,0);
            
            %concatinate all 3 transforms
            transforms = cat(3,T0to2, T2to3, T3to4);
            poses = zeros(4,4,size(transforms,3));
            
            %for all 4 frames
            for i = (1:size(transforms,3))
                if(i == 1) %For the first frame the pose is the transform
                    poses(:,:,i) = transforms(:,:,i);
                else %for everything else post mutiply with previous pose
                    poses(:,:,i) = poses(:,:,i-1) * transforms(:,:,i);
                end
            end
            %now all poses and frames are ready
            
            cla %clear only data from figure
            
            x = zeros(4,1);
            y = zeros(4,1);
            z = zeros(4,1);
            
            %first triad always at base
            triad('Parent',obj.mainAxes,'Scale',30,'LineWidth',3);
            
            %create triads at each frame
            for i = (1:size(poses,3))
                triad('Parent',obj.mainAxes,'Scale',30,'LineWidth',3,'Matrix',poses(:,:,i));
                x(i+1) = poses(1,4,i);
                y(i+1) = poses(2,4,i);
                z(i+1) = poses(3,4,i);
            end
            
            %plot the ball and stick and label stuff
            plot3(x,y,z,'-o','LineWidth',4,'MarkerSize',10,'MarkerFaceColor',[0.5,0.5,0.5]);grid on;
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

