classdef OrbList
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
      
    properties
        pinkOrb
        yellowOrb
        purpleOrb
        greenOrb
        activeColor
    end
    
    
    methods
        function obj = OrbList()
            obj.pinkOrb = 0;
            obj.yellowOrb = 0;
            obj.purpleOrb = 0;
            obj.greenOrb = 0;
        end
        
        function obj = addOrbToList(obj,Orb)
            color = Orb.color;
            switch color
                case Colors.PINK
                    obj.pinkOrb = Orb;
                case Colors.YELLOW
                    obj.yellowOrb = Orb;
                case Colors.PURPLE
                    obj.purpleOrb = Orb;
                case Colors.GREEN
                    obj.greenOrb = Orb;
                otherwise
                    disp("ERROR, Incorrect Orb Color. Not placed in List")
            end    
        end
        
        function orb = getActiveOrb(obj)
            switch obj.activeColor
                case Colors.PINK
                    orb = obj.pinkOrb;
                case Colors.YELLOW
                    orb = obj.yellowOrb;
                case Colors.PURPLE
                    orb = obj.purpleOrb;
                case Colors.GREEN
                    orb = obj.greenOrb;
                otherwise
                    disp("ERROR, No color speicifed, don't knwo what to return")
            end
        end
        
        function obj = deleteActiveOrb(obj)
            switch obj.activeColor
                case Colors.PINK
                    obj.pinkOrb = 0;
                case Colors.YELLOW
                    obj.yellowOrb = 0;
                case Colors.PURPLE
                    obj.purpleOrb = 0;
                case Colors.GREEN
                    obj.greenOrb = 0;
                otherwise
                    disp("ERROR, Incorrect Orb Color. Not removed from List")
            end
        end
        
        function obj = deleteOrbFromList(obj,Orb)
            color = Orb.color;
            switch color
                case Colors.PINK
                    obj.pinkOrb = 0;
                case Colors.YELLOW
                    obj.yellowOrb = 0;
                case Colors.PURPLE
                    obj.purpleOrb = 0;
                case Colors.GREEN
                    obj.greenOrb = 0;
                otherwise
                    disp("ERROR, Incorrect Orb Color. Not removed from List")
            end
        end
        
        function length = getlistLength(obj)
            length = 4;
            if (obj.pinkOrb == 0), length = length-1; end
            if (obj.yellowOrb == 0), length = length-1; end
            if (obj.purpleOrb == 0), length = length-1; end
            if (obj.greenOrb == 0), length = length-1; end
        end
        
    end
end

