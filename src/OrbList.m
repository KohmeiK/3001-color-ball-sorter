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
                case Color.PINK
                    obj.pinkOrb = Orb;
                case Color.YELLOW
                    obj.yellowOrb = Orb;
                case Color.PURPLE
                    obj.purpleOrb = Orb;
                case Color.GREEN
                    obj.greenOrb = Orb;
                otherwise
                    disp("ERROR, Incorrect Orb Color. Not placed in List")
            end
        end
        
        function orb = getActiveOrb(obj)
            switch obj.activeColor
                case Color.PINK
                    orb = obj.pinkOrb;
                case Color.YELLOW
                    orb = obj.yellowOrb;
                case Color.PURPLE
                    orb = obj.purpleOrb;
                case Color.GREEN
                    orb = obj.greenOrb;
                otherwise
                    orb = 0;
                    disp("Color is all, retruing empty orb")
            end
            
            if(~isa(orb,"Orb"))
                disp("Orb was not here creating a empty orb");
                orb = Orb(Color.ALL,[0 0 0],[0 0 0],0);
            end
        end
        
        function obj = deleteActiveOrb(obj)
            switch obj.activeColor
                case Color.PINK
                    obj.pinkOrb = 0;
                case Color.YELLOW
                    obj.yellowOrb = 0;
                case Color.PURPLE
                    obj.purpleOrb = 0;
                case Color.GREEN
                    obj.greenOrb = 0;
                otherwise
                    disp("ERROR, Incorrect Orb Color. Not removed from List")
            end
        end
        
        function obj = deleteOrbFromList(obj,Orb)
            color = Orb.color;
            switch color
                case Color.PINK
                    obj.pinkOrb = 0;
                case Color.YELLOW
                    obj.yellowOrb = 0;
                case Color.PURPLE
                    obj.purpleOrb = 0;
                case Color.GREEN
                    obj.greenOrb = 0;
                otherwise
                    disp("ERROR, Incorrect Orb Color. Not removed from List")
            end
        end
        
        function length = getlistLength(obj)
            length = 4;
            if ~isa(obj.pinkOrb,'Orb'), length = length-1; end
            if ~isa(obj.greenOrb,'Orb'), length = length-1; end
            if ~isa(obj.yellowOrb,'Orb'), length = length-1; end
            if ~isa(obj.purpleOrb,'Orb'), length = length-1; end
        end
        
    end
end

