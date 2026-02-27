%{
    Copyright (c) 2025 Axion BioSystems, Inc.
    Contact: support@axion-biosystems.com
    All Rights Reserved
%}
classdef Tag < handle  & matlab.mixin.Heterogeneous & matlab.mixin.CustomDisplay
   %TAG Base class of user genreated metadata for a file
   %   Currently, AxionFileTags include Annotation (from the play bar),
   %   StimulationEvent (when stimulations occur), and WellInformation
   %   (from the Plate Map Editor).

   properties (GetAccess = private, SetAccess = private)
      EntryNodes;
   end

   properties (GetAccess = public, SetAccess = private)
      % TagGuid: Unique GUID for this tag and its revision history.
      % When a new tag is added to a TagCollection, if its GUID matches
      % that of an existing tag, that tag is updated with the new tag as a revision.
      TagGuid;

      % HeadRevisionNumber: Each Revision of a tag by axis has a new,
      % iterated revison number. This is the most recent tag's revision
      % number
      HeadRevisionNumber;

      %Type: The TypeID attributed to this tag
      Type;
   end

   methods
      function this = Tag(varargin)
         this = this@handle();
         this@matlab.mixin.Heterogeneous();
         this@matlab.mixin.CustomDisplay();

         if nargin == 0
            % Default GUID enables axion_empty() typed-empty construction.
            aGuid = '';
         elseif nargin == 1
            aGuid = varargin{1};
         else
            error('Tag: Argument Error');
         end

         this.TagGuid = aGuid;
         this.HeadRevisionNumber = -1;
         % Use axion_empty() because TagEntry.empty(...) is not reliable in
         % Octave classdef object arrays.
         this.EntryNodes = axion_empty('TagEntry', 0, 1);
      end

      function new = Promote(this, aFileId)
         %%% Promote:
         % Converts a base tag to the type that is dictated by its Type
         % property. Note that the returned object is a new instance
         fNumEntries = length(this.EntryNodes);
         fRevisions = zeros(1, fNumEntries);
         for i = 1:fNumEntries
            fRevisions(i) = double(this.EntryNodes(i).RevisionNumber);
         end
         [~,idx] = sort(fRevisions);
         fEntryNodes = this.EntryNodes(idx);
         fHead = fEntryNodes(end);

         try
            switch fHead.Type
               case TagType.UserAnnotation
                  new = Annotation(aFileId, fHead);
               case TagType.SystemAnnotation
                  new = Annotation(aFileId, fHead);
               case TagType.WellTreatment
                  new = WellInformation(aFileId, fHead);
               case TagType.StimulationEvent
                  new = StimulationEvent(aFileId, fHead);
               case TagType.StimulationChannelGroup
                  new = StimulationChannels(aFileId, fHead);
               case TagType.StimulationWaveform
                  new = StimulationWaveform(aFileId, fHead);
               case TagType.CalibrationTag
                  %For Calibration Tags, No Additonal Parsing supported
                  new = Tag(this.TagGuid);
               case TagType.StimulationLedGroup
                  new = StimulationLeds(aFileId, fHead);
               case TagType.DoseEvent
                  new = Tag(this.TagGuid); %Quietly ignored, No Additonal Parsing supported
               case TagType.StringDictonaryKeyPair
                  new = KeyValuePairTag(aFileId, fHead);
               case TagType.LeapInductionEvent
                  new = LeapInductionEvent(aFileId, fHead);
               case TagType.ViabilityImpedanceEvent
                  new = ViabilityImpedanceEvent(aFileId, fHead);
               otherwise
                  new = Tag(this.TagGuid);
                  if(this.Type ~= TagType.Deleted)
                     warning('Unknown Tag Type found. Is this loader out of date?');
                  end
            end
            new.Type = fHead.Type;
         catch fError
            warning('Could not load tag - %s', fError.message);

            % Create a dummy tag and treat it as 'Deleted'
            new = Tag(this.TagGuid);
            new.Type = TagType.Deleted;
         end
         new.EntryNodes = fEntryNodes;
         new.HeadRevisionNumber = fHead.RevisionNumber;

      end

      function AddNode(this, aNode)
         %%% AddNode
         % Adds a TagEntry to the revision history of this Tag series
         if isempty(this.EntryNodes)
            this.EntryNodes = aNode;
         else
            this.EntryNodes(end + 1, 1) = aNode;
         end
         %sort by revison number
         fNumEntries = length(this.EntryNodes);
         fRevisions = zeros(1, fNumEntries);
         for i = 1:fNumEntries
            fRevisions(i) = double(this.EntryNodes(i).RevisionNumber);
         end
         [this.HeadRevisionNumber, idx] = max(fRevisions);
         this.Type = this.EntryNodes(idx).Type;
      end
   end

end
