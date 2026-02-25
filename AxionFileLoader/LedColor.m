%{
    Copyright (c) 2025 Axion BioSystems, Inc.
    Contact: support@axion-biosystems.com
    All Rights Reserved
%}
classdef LedColor
    %LEDCOLOR Color of a Stimulating LED
    properties (Constant = true)
        % None: Indicates that a color hasn't been assigned yet.
        None = uint16(0);

        % None: Indicates that this was a Blue Led
        Blue = uint16(1);

        % None: Indicates that this was an Orange Led
        Orange = uint16(2);

        % None: Indicates that this was a Green Led
        Green = uint16(3);

        % None: Indicates that this was a Red Led
        Red = uint16(4);
    end

    methods (Static = true)
        function [value, success] = TryParse(aInput)
            value = uint16(aInput);
            known = [LedColor.None, LedColor.Blue, LedColor.Orange, LedColor.Green, LedColor.Red];
            success = any(value == known);
        end
    end
end
