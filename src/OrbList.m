classdef OrbList
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
      
    properties
        Orbs;
    end
    
    
    methods
        function obj = OrbList()
        end
        
        function addOrbToList(obj,Orb)
            color = Orb.color;
            switch color
                case Colors.PINK
                    obj.Orbs(1) = Orb;
                case Colors.YELLOW
                    obj.Orbs(1) = Orb;
                case Colors.PURPLE
                    obj.Orbs(3) = Orb;
                case Colors.GREEN
                    obj.Orbs(4) = Orb;
                otherwise
                    disp("ERROR, Incorrect Orb Color. Not placed in List")
            end    
        end
        
        function deleteOrbFtomList(obj,Orb)
            color = Orb.color;
            switch color
                case Colors.PINK
                    obj.Orbs(1) = 0;
                case Colors.YELLOW
                    obj.Orbs(2) = 0;
                case Colors.PURPLE
                    obj.Orbs(3) = 0;
                case Colors.GREEN
                    obj.Orbs(4) = 0;
                otherwise
                    disp("ERROR, Incorrect Orb Color. Not removed from List")
            end
        end
        
        function length = getlistLength(obj)
            length = 0;
            
            for i = 1:4
                if obj.Orbs(i) ~= 0
                    length = length + 1;
                end
            end
        end
        
    end
end

