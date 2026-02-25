classdef (HandleCompatible) PropertyGroup < handle
    properties
        PropertyList
    end

    methods
        function this = PropertyGroup(property_list)
            if nargin > 0
                this.PropertyList = property_list;
            else
                this.PropertyList = struct();
            end
        end
    end
end
