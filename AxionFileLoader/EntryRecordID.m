%{
    Copyright (c) 2025 Axion BioSystems, Inc.
    Contact: support@axion-biosystems.com
    All Rights Reserved
%}
classdef EntryRecordID
    %ENTRYRECORDID Values for entry record types used in headers /
    %   subheaders
    % NOTE: This is implemented as constants (not MATLAB enums) so Octave
    % can parse the file format without enum base-type support.
    %
    %   Terminate: Used to indicate the end of the record entries in
    %   headers/ subheaders.
    %
    %   Skip: Indicates an area of the file to be ignored.
    %
    %   NotesArray: see Notes.m
    %
    %   ChannelArray: see ChannelArray.m
    %
    %   BlockVectorHeader: see BlockVectorHeader.m
    %
    %   BlockVectorData: see BlockVectorData.m
    %
    %   BlockVectorHeaderExtension: see BlockVectorHeaderExtension.m
    %
    %   CombinedBlockVectorHeader: see CombinedBlockVectorHeaderEntry.m
    %

    properties (Constant = true)
        Terminate = uint8(hex2dec('00'));
        Skip = uint8(hex2dec('ff'));
        NotesArray = uint8(hex2dec('01'));
        ChannelArray = uint8(hex2dec('02'));
        BlockVectorHeader = uint8(hex2dec('03'));
        BlockVectorData = uint8(hex2dec('04'));
        BlockVectorHeaderExtension = uint8(hex2dec('05'));
        Tag = uint8(hex2dec('06'));
        CombinedBlockVectorHeader = uint8(hex2dec('07'));
    end

    methods(Static)
        function [value , success] = TryParse(aInput)
            % Keep parsing tolerant by returning the raw numeric ID and a
            % success flag, mirroring former enum-constructor validation.
            value = uint8(aInput);
            known = [ ...
                EntryRecordID.Terminate, ...
                EntryRecordID.Skip, ...
                EntryRecordID.NotesArray, ...
                EntryRecordID.ChannelArray, ...
                EntryRecordID.BlockVectorHeader, ...
                EntryRecordID.BlockVectorData, ...
                EntryRecordID.BlockVectorHeaderExtension, ...
                EntryRecordID.Tag, ...
                EntryRecordID.CombinedBlockVectorHeader ...
            ];
            success = any(value == known);
            if ~success
                warning('EntryRecordID:TryParse', 'Unsupported EntryRecordID: %d', value);
            end
        end
    end

end
