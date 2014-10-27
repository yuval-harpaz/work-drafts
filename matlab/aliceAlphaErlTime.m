cd /home/yuval/Data/Erlangen
load Subs
Subs=Subs([1:3,5:7,9:14]);
cfn='lf,hb_c,rfhp0.1Hz';
temp=[-50:50,49:-1:-50];
sRate=2034.51;
for subi=1:length(Subs)
    subFold=Subs{subi};
    cd([subFold,'/1'])
    cfg=[];
    cfg.dataset=cfn;
    cfg.channel='MEG';
    cfg.trl=[round(sRate*3),63*sRate,0];
    cfg.demean='yes';
    cfg.hpfilter='yes';
    cfg.hpfreq=6;
    meg=ft_preprocessing(cfg);
    [f,~]=fftBasic(meg.trial{1,1},678.17);
    fftTopoMEG(1:248,subi)=mean(abs(f(:,9:11)),2);
    %save(['fftTopoMEG',num2str(subi)],'fftTopoMEG');
    load /home/yuval/Data/Denis/REST/neighbours
    cfg=[];
    cfg.planarmethod   = 'orig';
    cfg.neighbours     = neighbours;
    cfg.layout='4D248.lay';
    interp = ft_megplanar(cfg, meg);
    meg = ft_combineplanar([], interp);
    blank=[];
    for chi=1:248
        str=[subFold,' MEG ',num2str(chi)];
        samps=getAlphaSamps(meg.trial{1,1}(chi,:),temp,1,'v0.1');
        timeTopoMEG(chi,subi)=100*length(samps)./length(meg.time{1,1}); %#ok<AGROW>
        disp([blank,str]);
        blank=repmat(sprintf('\b'), 1, length(str)+1);
    end
    cd ../..
    %save(['timeTopoMEG',num2str(subi)],'timeTopoMEG');
    [f,~]=fftBasic(meg.trial{1,1},678.17);
    fftTopoMEG(1:248,subi)=mean(abs(f(:,9:11)),2);
end
save timeTopo *Topo*;