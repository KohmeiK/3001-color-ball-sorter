classdef OrbList
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
      
    properties
 
    end
    
    
    methods
        function obj = OrbList()
            import java.util.ArrayList
        end
        
        function addOrbToList(obj,Orb)
            color = Orb.color;
            switch color
                case PINK
                    obj.add(1 , Orb);
                case YELLOW
                    obj.add(2 , Orb);
                case PURPLE
                    obj.add(3 , Orb);
                case GREEN
                    obj.add(4 , Orb);
                otherwise
                    disp("ERROR, Incorrect Orb Color. Not placed in List")
            end    
        end
        
        function deleteOrbFtomList(obj,Orb)
            color = Orb.color;
            switch color
                case PINK
                    obj.add(1 , Orb);
                case YELLOW
                    obj.add(2 , Orb);
                case PURPLE
                    obj.add(3 , Orb);
                case GREEN
                    obj.add(4 , Orb);
                otherwise
                    disp("ERROR, Incorrect Orb Color. Not placed in List")
            end
        end
        
        function length = getlistLength(obj)
            length = 0;
            
            for i = 1:4
                if isEmpty(obj.get(i))
                    length = length + 1;
                end
            end
        end
        
    end
end

