function DenisLF
cd ~/Data/Denis/main_fifs
subs=[200447;202752;203175;203235;203267;203728;203822;204265;204510;204707;204718;204743;204985;204990;204991;205040;205201;205104;];
%load subs.mat subs
close all
% subs=1*subs;
for subi=1:length(subs)
    sub=num2str(subs(subi));
    cd(sub)
    infile='main_raw.fif';
    outfile='main_lf_raw.fif';
    %if ~exist(outfile,'file');
    raw=fiff_setup_read_raw(infile);
    [data,times] = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp,1:248);
    [M258,times] = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp,258);
    dataLf=correctLF(data,raw.info.sfreq,M258,'ADAPTIVE',50,4);
    clear data
    saveas(1,'lf_M258.tiff');
    close
    disp(['saving dataLf for ',sub])
    copyfile(infile,outfile);
    [outfid,cals] = fiff_start_writing_raw(outfile,raw.info);
    [data,times] = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp);
    data(1:248,:)=dataLf;
    clear dataLf
    fiff_write_raw_buffer(outfid,data,cals);
    fiff_finish_writing_raw(outfid);
    clear data
    if exist ('dataLf.mat','file')
        !rm dataLf.mat
    end
    cd ..
end