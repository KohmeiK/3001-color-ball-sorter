classdef CV
    %CV Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        state
        currentActiveColor
        Camera
        image
    end
    
    methods
        function obj = CV()
            obj.Camera = Camera();
            obj.Camera.DEBUG = DEBUG_CAM;
            obj.extrinsticCalibration();
            
            obj.currentActiveColor = Colors.All;
            obj.state = CVState.INIT;
        end
        
        function obj = extrinsticCalibration(obj)
            % Set up camera
            if obj.Camera.params == 0
                error("No camera parameters found!");
            end
            %outputs a transformation Matrix
            obj.Camera.cam_pose = obj.Camera.getCameraPose();
            
        end
        
        function obj = update(obj)
            switch(obj.state)
                case CVState.INIT %Step 1
                    %Init something if we need to
                case CVState.STEP1 %Step 1
                    obj = obj.step1();
                case CVState.STEP2 %Step 2
                    obj = obj.step2();
                case CVState.IDLE %Step 3
                    %Do nothing
            end
        end
        
        function obj = step1(obj)
            obj.image = snapshot(cam.cam);
        end
        
        function obj = step2(obj)
            [obj.image, ~] = undistortImage(newImg, obj.Camera.params.Intrinsics, 'OutputView', 'full');
            
            % Convert the image to the HSV color space.
            [obj.image,~] = yellowMask(obj.image);
        end
        
        %LAST STEP
        function newArray = updateArray(~,newArray)
            %update the array with with the new one
            %also update isMoved state
            newArray(1) = 0;
        end
    end
end

