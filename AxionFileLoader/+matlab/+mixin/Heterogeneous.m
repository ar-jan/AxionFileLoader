classdef (HandleCompatible) Heterogeneous
    % Minimal shim for Octave where matlab.mixin.Heterogeneous is missing.
    % This preserves inheritance chains used by AxionFileLoader classes.
    methods
        function this = Heterogeneous(varargin)
        end
    end
end
