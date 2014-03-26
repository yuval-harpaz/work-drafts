function DenisHBtest
cd ~/Data/Denis/main_fifs
subs=[200447;202752;203175;203235;203267;203728;203822;204265;204510;204707;204718;204743;204985;204990;204991;205040;205201;205104;];
%load subs.mat subs
close all
% subs=1*subs;
infile='main_lf_raw.fif';
outfile='main_lfhb_raw.fif';
for subi=[1:3,5:17]
    sub=num2str(subs(subi));
    cd(sub)
    
    %if ~exist(outfile,'file');
    raw=fiff_setup_read_raw(infile);
    if ~exist('./dataLf.mat','file')
        data = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp,1:248);
        save dataLf data -v7.3
        clear data
    end
    
    if subi==1
        cfg=[];
        %cfg.afterHBs=0.85;
        cfg.repressTime=100;
        [dataLfHb,HBtimes,temp,~,~,topo]=correctHB('dataLf.mat',raw.info.sfreq,[],[],cfg);
    elseif subi==7
        cfg.repressTime=100;
        cfg.afterHBs=0.55;
        [dataLfHb,HBtimes,temp,~,~,topo]=correctHB('dataLf.mat',raw.info.sfreq,[],[],cfg);
    elseif subi==8
        cfg.afterHBs=0.55;
        [dataLfHb,HBtimes,temp,~,~,topo]=correctHB('dataLf.mat',raw.info.sfreq,[],[],cfg);
    else
        [dataLfHb,HBtimes,temp,~,~,topo]=correctHB('dataLf.mat',raw.info.sfreq);
    end
    save HBdata HBtimes temp topo
    save dataLfHb dataLfHb -v7.3
    clear dataLfHb
    saveas(1,'raw.fig');
    %saveas(1,'raw.tif');
    saveas(2,'avg.tif');
    close all

%     if ~exist(['./',outfile],'file')
%         copyfile(infile,outfile);
%     end
%     [outfid,cals] = fiff_start_writing_raw(outfile,raw.info);
%     data = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp);
    % load dataLfHb
%     data(1:248,:)=dataLfHb;
    clear dataLfHb
    load dataLf
    clear data
%     fiff_write_raw_buffer(outfid,data,cals);
%     fiff_finish_writing_raw(outfid);
%     clear data
    if exist ('dataLf.mat','file')
        !rm dataLf.mat
    end
    if exist ('dataLfHb.mat','file')
        !rm dataLfHb.mat
    end
    cd ..
end