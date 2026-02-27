%{
    Copyright (c) 2025 Axion BioSystems, Inc.
    Contact: support@axion-biosystems.com
    All Rights Reserved
%}
classdef BlockVectorDataType
    %BLOCKVECTORDATATYPE Enumeration of known types of block vector data.
    % NOTE: Implemented as constants (not MATLAB enums) for Octave
    % compatibility with numeric-backed enum references.
    %
    %   Raw_v1:     Continuous data from an Axion Muse or Maestro device.
    %
    %   Spike_v1:   Binary Spike Data recorded by a Spike detector in Axis.
    %
    %   NamedContinuousData: Continous data where every track of data has
    %   an associated channel and name
    %

    properties (Constant = true)
        Raw_v1 = uint16(0);
        Spike_v1 = uint16(1);
        NamedContinuousData = uint16(2);
    end

    methods(Static)
        function [value , success] = TryParse(aInput)
            % TryParse preserves "unknown value" handling without relying
            % on enum constructor exceptions.
            value = uint16(aInput);
            known = [
                BlockVectorDataType.Raw_v1, ...
                BlockVectorDataType.Spike_v1, ...
                BlockVectorDataType.NamedContinuousData ...
            ];
            success = any(value == known);
            if ~success
                warning('BlockVectorDataType:TryParse', 'Unsupported BlockVectorDataType: %d', value);
            end
        end
    end

end
