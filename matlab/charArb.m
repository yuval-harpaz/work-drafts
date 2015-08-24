%% make subject list
cd ('/media/My Passport/Hila&Rotem')
load Sub


%% cleaning line frequency (25min per subject)

for subi=1:length(Sub)
    cd (Sub{subi})
    if ~exist('./lf_c,rfhp0.1Hz','file')
        close all;
        correctLF;
        saveas(1,'lf.png')
        close
    end
    cd ../
end

%% clean building vibrations (5min per subject)
for subi=1:length(Sub)
    cd (Sub{subi})
    if exist('./lf_c,rfhp0.1Hz','file') && ~exist('./hb,xc,lf_c,rfhp0.1Hz','file')
    p=pdf4D('lf_c,rfhp0.1Hz');
    cleanCoefs = createCleanFile(p, 'lf_c,rfhp0.1Hz',...
        'byLF',0 ,...
        'xClean',[4,5,6],...
        'byFFT',0,...
        'HeartBeat',0);
    end
    cd ../
end
%% cleaning heartbeat (5min per subject)


for subi=1:length(Sub)
    cd (Sub{subi})
    if exist('./xc,lf_c,rfhp0.1Hz','file') && ~exist('./hb,xc,lf_c,rfhp0.1Hz','file')
        close all;
        correctHB;
        saveas(1,'HBraw.fig')
        saveas(2,'HBmean.png')
        close all;
        movefile('hb_xc,lf_c,rfhp0.1Hz','hb,xc,lf_c,rfhp0.1Hz');
    end
    cd ../
end

%% clean directory
cd ('/media/My Passport/Hila&Rotem')
load Sub
for subi=1:length(Sub)
    cd (Sub{subi})
    if exist('./hb,xc,lf_c,rfhp0.1Hz','file')
        !rm xc,*
        !rm lf_*
    end
    cd ../
end

%% 