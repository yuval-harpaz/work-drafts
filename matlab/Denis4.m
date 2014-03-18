function Denis4
cd ~/Data/Denis/main_fifs
subs=[200447;202752;203175;203235;203267;203728;203822;204265;204510;204707;204718;204743;204985;204990;204991;205040;205201;205104;];
%load subs.mat subs
close all
% subs=1*subs;
for subi=1:length(subs)
    sub=num2str(subs(subi));
    cd(sub)
    infile='main_raw.fif';
    if subi==1 || subi==18 % no HB
        outfile='main_lf_raw.fif';
        doHB=false;
    else
        outfile='main_lfhb_raw.fif';
        doHB=true;
    end
    %if ~exist(outfile,'file');
    raw=fiff_setup_read_raw(infile);
    [data,times] = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp,1:248);
    if sum(subi==[13,15,16,17])
        [M258,times] = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp,258);
        % matlabpool;
        %         hpObj=fdesign.highpass('Fst,Fp,Ast,Ap',0.1,1,60,1,raw.info.sfreq);%
        %         Filt=design(hpObj ,'butter');
        %         dataf = myFilt(data,Filt);
        %         meanMEG=mean(data,1);
        %         meanMEGf = myFilt(meanMEG,Filt);
        %         figure;plot(meanMEG);hold on;plot(meanMEGf,'r');
        %dataLf=correctLF(data,raw.info.sfreq,'time','ADAPTIVE',50);
        % dataLf=correctLF(data,raw.info.sfreq,'time','ADAPTIVE',30);
        dataLf=correctLF(data,raw.info.sfreq,M258,'ADAPTIVE',50);
    else
        dataLf=correctLF(data,raw.info.sfreq,'time','ADAPTIVE',50);
    end
    clear data
    saveas(1,'lf.tiff');
    close
    disp(['saving dataLf for ',sub])
    if doHB
        save dataLf dataLf -v7.3
        clear dataLf
        dataLfHb=correctHB('dataLf.mat',raw.info.sfreq);
        saveas(1,'hb.fig');
        close
    else
        dataLfHb=dataLf;
        clear dataLf
    end
    copyfile(infile,outfile);
    [outfid,cals] = fiff_start_writing_raw(outfile,raw.info);
    [data,times] = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp);
    data(1:248,:)=dataLfHb;
    clear dataLfHb
    fiff_write_raw_buffer(outfid,data,cals);
    fiff_finish_writing_raw(outfid);
    clear data
    if exist ('dataLf.mat','file')
        !rm dataLf.mat
    end
    cd ..
end