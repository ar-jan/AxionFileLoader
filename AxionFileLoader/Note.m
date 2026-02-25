%{
    Copyright (c) 2025 Axion BioSystems, Inc.
    Contact: support@axion-biosystems.com
    All Rights Reserved
%}
classdef Note < Entry
    %Note Container class for Axis File notes
    %
    %   Investigator:   Text data taken from 'Investigator' field of the Axis
    %                   GUI
    %
    %   ExperimentID:   Text data taken from 'Recording Name' field of the Axis
    %                   GUI
    %
    %   Description:    Text data taken from 'Description' field of the Axis
    %                   GUI
    %
    %   Revision:       Number of revisions this note has experienced
    %
    %   RevisionDate:   Date this note was last revised (See DateTime.m)
    properties (Constant = true, GetAccess = public)
        SIZE = 618;
    end

    properties (Constant = true, GetAccess = private)
        %Constants for offsets and sizes in binary notes entries.
        RecordingNameOffset = 50;
        DescriptionOffset = 100;
        RevisionOffset = 600;
        InvestigatorLength = 50;
        RecordingNameLength = 50;
        DescriptionLength = 500;
    end

    properties (GetAccess = public, SetAccess = private)
        Investigator
        RecordingName
        Description
        Revision
        RevisionDate
    end

    methods
        function this = Note(varargin)
            if nargin == 0
                this = this@Entry();
                this.Investigator = [];
                this.RecordingName = [];
                this.Description = [];
                this.Revision = [];
                this.RevisionDate = [];
                return;
            elseif nargin == 2
                aEntryRecord = varargin{1};
                aFileID = varargin{2};
            else
                error('Note: Argument Error');
            end

            this = this@Entry(aEntryRecord, int64(ftell(aFileID)));

            this.Investigator = deblank(fread(aFileID, Note.InvestigatorLength, '*char').');
            % strip '\r' characters so that lines aren't double-spaced
            this.Investigator(this.Investigator==13)=[];

            fseek(aFileID, this.Start + Note.RecordingNameOffset, 'bof');
            this.RecordingName = deblank(fread(aFileID, Note.RecordingNameLength, '*char').');
            % strip '\r' characters so that lines aren't double-spaced
            this.RecordingName(this.RecordingName==13)=[];

            fseek(aFileID, this.Start + Note.DescriptionOffset, 'bof');
            this.Description = deblank(fread(aFileID, Note.DescriptionLength, '*char').');
            % strip '\r' characters so that lines aren't double-spaced
            this.Description(this.Description==13)=[];

            fseek(aFileID, this.Start + Note.RevisionOffset, 'bof');
            this.Revision = fread(aFileID, 1, 'uint32=>uint32');
            this.RevisionDate = DateTime(aFileID);

            if(ftell(aFileID) ~= (this.Start + this.EntryRecord.Length))
                error('Unexpected BlockVectorHeader length')
            end

        end
    end

    methods(Static = true)
        function array = ParseArray(aEntryRecord, aFileID)
            fCount = aEntryRecord.Length / Note.SIZE;
            array = axion_empty('Note', 0, fCount);
            for i = 1 : fCount
                fEntryRecord = EntryRecord(EntryRecordID.NotesArray, Note.SIZE);
                array(i) = Note(fEntryRecord, aFileID);
            end
        end
    end
end
