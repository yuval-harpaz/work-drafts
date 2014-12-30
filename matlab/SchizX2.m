function SchizX2
cd /media/yuval/Elements/SchizoRestMaor
load Subs
load SubsXtimes
xSubs=find(ismember(Subs(:,3),'x'));
for subi=1:length(xSubs)
    sub=Subs{xSubs(subi),1};
    cd(sub)
    if exist('datacln.mat','file') && ~exist('dataica.mat','file')
        datacln=[];
        load datacln
        cfg=[];
        cfg.bpfilter='yes';
        cfg.bpfreq=[1 40];
        data4ica=ft_preprocessing(cfg,datacln);
        %         cfg2=cfg;
        % cfg2.bpfreq=[1 40];
        % data4ica=ft_preprocessing(cfg2,datacln);
        %
        cfg            = [];
        cfg.resamplefs = 300;
        cfg.detrend    = 'no';
        dummy           = ft_resampledata(cfg, data4ica);
        
        % run ica (it takes a long time have a break)
        cfg            = [];
        cfg.channel    = 'MEG'; %cfg.channel = {'MEG','-A74'};
        comp_dummy     = ft_componentanalysis(cfg, dummy);
        
        % see the components and find the artifacts
        cfgb=[];
        cfgb.layout='4D248.lay';
        cfgb.channel = {comp_dummy.label{1:5}};
        cfgb.continuous='no';
        comppic=ft_databrowser(cfgb,comp_dummy);
        
        % run the ICA on the original data
        cfg = [];
        cfg.topo      = comp_dummy.topo;
        cfg.topolabel = comp_dummy.topolabel;
        comp     = ft_componentanalysis(cfg, datacln);
        %
        % % remove the artifact components
        cfg = [];
        cfg.component = [1 2]; % change
        dataica = ft_rejectcomponent(cfg, comp);
        dataica=correctBL(dataica);
%         cfg=[];
%         cfg.method='summary';
%         cfg.channel='MEG';
%         datacln=ft_rejectvisual(cfg, dataica);
        save dataica dataica
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


