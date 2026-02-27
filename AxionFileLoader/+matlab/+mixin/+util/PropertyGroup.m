classdef (HandleCompatible) PropertyGroup < handle
    % Minimal shim for Octave where matlab.mixin.util.PropertyGroup
    % is unavailable; only PropertyList storage is required.
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
