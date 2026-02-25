classdef (HandleCompatible) CustomDisplay
    methods
        function this = CustomDisplay(varargin)
        end
    end

    methods (Access = protected)
        function propgrp = getPropertyGroups(~)
            propgrp = matlab.mixin.util.PropertyGroup(struct());
        end
    end
end
