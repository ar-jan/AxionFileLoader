%{
    Copyright (c) 2025 Axion BioSystems, Inc.
    Contact: support@axion-biosystems.com
    All Rights Reserved
%}
classdef Annotation < EventTag
    %ANNOTATION tag that correspond to events listed in AxIS's play bar
    properties(GetAccess = public, SetAccess = private)
       NoteText;
    end

    methods
        function this = Annotation(varargin)
            if nargin == 0
                this = this@EventTag();
                this.NoteText = [];
                return;
            elseif nargin == 2
                aFileID = varargin{1};
                aRawTag = varargin{2};
            else
                error('Annotation: Argument Error');
            end

            this = this@EventTag(aFileID, aRawTag);

            %Assume EventTag constructor leaves us at the right place
            fWellColumn      = fread(aFileID, 1, 'uint8=>uint8');
            fWellRow         = fread(aFileID, 1, 'uint8=>uint8');
            fElectrodeColumn = fread(aFileID, 1, 'uint8=>uint8');
            fElectrodeRow    = fread(aFileID, 1, 'uint8=>uint8');

            %Annotations are always broadcast
            if fWellColumn ~= 0 ||  fWellRow ~= 0 || ...
               fElectrodeColumn ~= 0 ||  fElectrodeRow ~= 0
               warning('File may be corrupt');
            end

            this.NoteText = freadstring(aFileID);

            fStart = aRawTag.Start + TagEntry.BaseSize;
            if ftell(aFileID) >  (fStart + aRawTag.EntryRecord.Length)
                warning('File may be corrupt');
            end

        end
    end

end
