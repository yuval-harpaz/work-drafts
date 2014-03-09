function Denis2
cd ~/Data/Denis/REST
load subs.mat subs
close all
% subs=1*subs;
for subi=1:length(subs)
    sub=num2str(subs(subi));
    cd(sub)
    infile='rest-raw.fif';
    outfile='clean-raw.fif';
    if ~exist(outfile,'file'); 
        raw=fiff_setup_read_raw(infile);
        [data,times] = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp,1:248);
        % matlabpool;
        dataLf=correctLF(data,raw.info.sfreq,'time','ADAPTIVE',50);
        saveas(1,'lf.tiff');
        close
        dataLfHb=correctHB(dataLf,raw.info.sfreq);
        saveas(1,'hb.fig');
        close
        copyfile(infile,outfile);
        [outfid,cals] = fiff_start_writing_raw(outfile,raw.info);
        [data,times] = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp);
        data(1:248,:)=dataLfHb;
        fiff_write_raw_buffer(outfid,data,cals);
        fiff_finish_writing_raw(outfid);
    end
    cd ..
end