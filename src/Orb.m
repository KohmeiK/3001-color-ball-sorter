classdef Orb
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Color of the Orb
        color
        
        %Current position of the orb in the task space([X Y])
        currentPos
        
        %Final destination where the Orb is to be placed, decided based on color
        finalPos
        
        %Has the Orb been moved?(Extra Credit) 1 if true/0 if false
        moved
        
    end
    
    methods
        function obj = Orb(Color,CurrentPosition,FinalPosition,Moved)
            %Set each of the properties described above
            obj.color = Color;
            obj.currentPos = CurrentPosition;
            obj.finalPos = FinalPosition;
            obj.moved = Moved;
        end
    end
end

