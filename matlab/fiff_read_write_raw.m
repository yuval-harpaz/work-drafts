function fiff_read_write_raw(infile,outfile,myData,picks)
%
% function mne_ex_read_write_raw(infile,outfile);
%
% Read and write raw data in 60-sec blocks
%

%
%   Author : Matti Hamalainen, MGH Martinos Center
%   License : BSD 3-clause
%   The function was modified by Yuval Harpaz


global FIFF;
if isempty(FIFF)
   FIFF = fiff_define_constants();
end
%
me = 'MNE:mne_ex_read_write_raw';
%
if nargin ~= 3
    error(me,'Incorrect number of arguments');
end
%
%   Setup for reading the raw data
%
try
    raw = fiff_setup_read_raw(infile);
catch
    error(me,'%s',mne_omit_first_line(lasterr));
end


%
[outfid,cals] = fiff_start_writing_raw(outfile,raw.info);
%
%   Set up the reading parameters
%
from        = raw.first_samp;
to          = raw.last_samp;
quantum_sec = 10;
quantum     = ceil(quantum_sec*raw.info.sfreq);
%
%   To read the whole file at once set
%
%quantum     = to - from + 1;
%
%
%   Read and write all the data
%
first_buffer = true;
for first = from:quantum:to
    last = first+quantum-1;
    if last > to
        last = to;
    end
    try
        [ data, times ] = fiff_read_raw_segment(raw,first,last);
    catch
        fclose(raw.fid);
        fclose(outfid);
        error(me,'%s',mne_omit_first_line(lasterr));
    end
    data(1:248,:)=myData(:,first+1:last+1);
    %
    %   You can add your own miracle here
    %
    fprintf(1,'Writing...');
    if first_buffer
       if first > 0
           fiff_write_int(outfid,FIFF.FIFF_FIRST_SAMPLE,first);
       end
       first_buffer = false;
    end
    fiff_write_raw_buffer(outfid,data,cals);
    fprintf(1,'[done]\n');
end

fiff_finish_writing_raw(outfid);
% fclose(outfid);
