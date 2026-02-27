classdef (HandleCompatible) CustomDisplay
    % Minimal shim for Octave where matlab.mixin.CustomDisplay is missing.
    % The loader only needs class inheritance + getPropertyGroups support.
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
