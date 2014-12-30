function SchizX
cd /media/yuval/Elements/SchizoRestMaor
load Subs
load SubsXtimes
xSubs=find(ismember(Subs(:,3),'x'));
for subi=1:length(xSubs)
    sub=Subs{xSubs(subi),1};
    cd(sub)
    if ~exist('dataRest.mat','file')
        fileName = source;
        if exist(['xc,hb,lf_',fileName],'file')
            fileName = ['xc,hb,lf_',fileName];
            read=true;
        elseif exist(['rs,xc,hb,lf_',fileName],'file')
            fileName = ['rs,xc,hb,lf_',fileName];
            read=true;
        else
            read=false;
        end
        if exist('splitconds.mat','file')
            read=false;
        end
        [~,xi]=ismember(sub,SubsXtimes(:,1));
        s=SubsXtimes{xi,2};
        e=SubsXtimes{xi,3};
        if ~isempty(s) && read
            epochedRest=s*1017:508.5:(e*1017)-1017;
            epochedRest=round(epochedRest);
            if epochedRest(1,1)==0
                epochedRest=epochedRest+1;
            end
            trlRest(1:size(epochedRest,2),1)=epochedRest';
            trlRest(1:size(epochedRest,2),2)=epochedRest'+1017;
            trlRest(1:size(epochedRest,2),3)=0;
            trlRest(1:size(epochedRest,2),4)=10; % code for rest
            
            hdr=ft_read_header(fileName);
            trlRest=trlRest(trlRest(:,2)<hdr.nSamples,:)
            cfg=[];
            cfg.trl=trlRest;
            cfg.dataset=fileName;
            cfg.trialfun='trialfun_beg';
            cfg=ft_definetrial(cfg);
            %findBadChans(fileName);
            %pause
            cfg.demean='no'; % normalize the data according to the base line average time1min window (see two lines below)
            cfg.continuous='yes';
            cfg.bpfilter='yes'; % apply bandpass filter (see one line below)
            cfg.bpfreq=[0.1 200];
            cfg.channel = 'MEG'; %cfg.channel = {'MEG','-A74'}; %MEG channels configuration. Take the MEG channels and exclude the minus ones
            dataorig=ft_preprocessing(cfg);
            
            % hdr=ft_read_header('xc,hb,lf_c1,rfhp0.1Hz'); % if I need to see the
            % number of samples in the original data
            
            save dataRest dataorig
        end
    end
    cd ../
    prog(subi);
end

disp('finish');
%         fileName=&& ~exist(['rs,xc,hb,lf_',source],'file')
%         try
%         p=pdf4D(fileName);
%         cleanCoefs = createCleanFile(p, fileName,...
%             'byLF',256,'Method','Adaptive',...
%             'xClean',[4,5,6],...
%             'chans2ignore',[],...
%             'byFFT',0,...
%             'HeartBeat',[],... % use [] for automatic HB cleaning, use 0 to avoid HB cleaning
%             'maskTrigBits', 256);
%         catch
%             disp(['createCleanFile failed for ',sub,'.'])
%         end


