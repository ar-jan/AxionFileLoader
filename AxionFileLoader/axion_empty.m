function values = axion_empty(class_name, varargin)
%AXION_EMPTY Octave-compatible replacement for classdef empty constructors.
%
% Octave classdef object arrays do not support all reshape patterns used by
% MATLAB's Class.empty. For this loader, a 0x0 typed object is sufficient
% because arrays are populated by indexed assignment after initialization.

    if nargin < 1 || isempty(class_name)
        error('axion_empty:MissingClass', 'class_name is required');
    end

    prototype = feval(class_name);
    values = prototype([]);
end
