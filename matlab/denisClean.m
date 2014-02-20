infile='rest-raw.fif';
outfile='clean-raw.fif';
raw=fiff_setup_read_raw(infile);
[data,times] = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp,1:248);
% matlabpool;
dataLf=correctLF(data,raw.info.sfreq,'time','ADAPTIVE',50);
[dataLfHb,HBtimes]=correctHB(dataLf,raw.info.sfreq,1);

copyfile(infile,outfile);
[outfid,cals] = fiff_start_writing_raw(outfile,raw.info);
[data,times] = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp);
data(1:248,:)=dataLfHb;
fiff_write_raw_buffer(outfid,data,cals);
fiff_finish_writing_raw(outfid);
