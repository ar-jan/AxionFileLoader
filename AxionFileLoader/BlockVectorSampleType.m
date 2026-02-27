%{
    Copyright (c) 2025 Axion BioSystems, Inc.
    Contact: support@axion-biosystems.com
    All Rights Reserved
%}
classdef BlockVectorSampleType
    %SampleType Encoding of the type of samples stored by a block vector
    % NOTE: Implemented as constants (not MATLAB enums) to avoid enum
    % inheritance limitations in Octave.
    %
    %   Short: Signed 16-bit numbers (little-endian)
    %
    %   Int: Signed 32-bit numbers (little-endian)
    %
    %   Float: 32-bit floating point numbers (IEEE 754)
    %
    %   Double: 64-bit floating point numbers (IEEE 754)
    %

    properties (Constant = true)
        Short = uint16(0);
        Int = uint16(1);
        Float = uint16(2);
        Double = uint16(3);
    end

    methods(Static)
        function [value , success] = TryParse(aInput)
            % Validate numeric IDs without enum construction.
            value = uint16(aInput);
            known = [
                BlockVectorSampleType.Short, ...
                BlockVectorSampleType.Int, ...
                BlockVectorSampleType.Float, ...
                BlockVectorSampleType.Double ...
            ];
            success = any(value == known);
            if ~success
                warning('BlockVectorSampleType:TryParse', 'Unsupported BlockVectorSampleType: %d', value);
            end
        end

        function value = GetSizeInBytes(aInput)
            switch uint16(aInput)
                case BlockVectorSampleType.Short
                    value = 2;
                case BlockVectorSampleType.Int
                    value = 4;
                case BlockVectorSampleType.Float
                    value = 4;
                case BlockVectorSampleType.Double
                    value = 8;
                otherwise
                    error('Unknown SampleType enum: %d', aInput);
            end
        end

        function precision = GetFreadPrecision(aInput)
            switch uint16(aInput)
                case BlockVectorSampleType.Short
                    precision = 'int16=>int16';
                case BlockVectorSampleType.Int
                    precision = 'int32=>int32';
                case BlockVectorSampleType.Float
                    precision = 'float32=>float32';
                case BlockVectorSampleType.Double
                    precision = 'float64=>float64';
                otherwise
                    error('Unknown SampleType enum: %d', aInput);
            end
        end
    end

end
