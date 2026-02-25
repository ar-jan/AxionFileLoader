%{
    Copyright (c) 2025 Axion BioSystems, Inc.
    Contact: support@axion-biosystems.com
    All Rights Reserved
%}
classdef TagEntry < Entry
    %TAGENTRY Section of an AxisFile that contains TagRevison

    properties(GetAccess = public, Constant = true)
        BaseSize = int64(2 + DateTime.Size + 16 + 4);
    end

    properties(GetAccess = public, SetAccess = private)
        % CreationDate: The date/time that this tag revision was created
        CreationDate;
        % TagGuid: GUID unique to this tag and its revisions
        TagGuid;
        % RevisionNumber: The number of times this tag has been revised up to this revision
        RevisionNumber;
        % Type: The type of event that created this tag (UserAnnotation, DataLossEvent, etc)
        Type;
    end

    methods
        function this = TagEntry(varargin)
            if nargin == 0
                this = this@Entry();
                this.CreationDate = [];
                this.TagGuid = '';
                this.RevisionNumber = [];
                this.Type = [];
                return;
            elseif nargin == 2
                aEntryRecord = varargin{1};
                aFileID = varargin{2};
            else
                error('TagEntry: Argument Error');
            end

            this = this@Entry(aEntryRecord, int64(ftell(aFileID)));

            fTypeShort = fread(aFileID, 1, 'uint16=>uint16');
            [fTagType, fSuccess] = TagType.TryParse(fTypeShort);
            if fSuccess
                this.Type = fTagType;
            else
                warning('TagEntry:UnknonwTagType', 'Unknown tag type %i will be ignored', fTypeShort);
                this.Type = TagType.Deleted;
            end
            this.CreationDate        = DateTime(aFileID);
            guidBytes                = fread(aFileID, 16, 'uint8=>uint8');
            this.TagGuid             = parseGuid(guidBytes);
            this.RevisionNumber      = fread(aFileID, 1, 'uint32=>uint32');

            %Seek to the end, we only parse the heads of the TagEntries as
            %the file loads
            fseek(aFileID, int64(this.EntryRecord.Length) - TagEntry.BaseSize, 'cof');

        end
    end

end
