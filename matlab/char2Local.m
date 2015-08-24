%% make subject list
cd ('/media/My Passport/Hila&Rotem')
DIR=dir('Char_*')
dIR=dir('char_*')
for subi=1:length(DIR)
    Sub{subi,1}=DIR(subi).name;
end
count=length(DIR)
for subi=1:length(dIR)
    count=count+1;
    Sub{count,1}=dIR(subi).name;
end
[~,bad]=ismember('Char_15',Sub)
Sub(bad)=[];
save Sub Sub
%% check that all folders have data in the right place
for subi=1:length(Sub)
    cd (Sub{subi})
    if ~exist('./c,rfhp0.1Hz','file')
        cd 0.14d1
        DIR=dir('*@*');
        cd (DIR.name)
        cd 1
        !mv config ../../../
        !mv c,rfhp0.1Hz ../../../
        !mv hs_file ../../../
        cd ../../../
    end
    cd ../
end



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
    p=pdf4D('lf_c,rfhp0.1Hz');
    cleanCoefs = createCleanFile(p, 'lf_c,rfhp0.1Hz',...
        'byLF',0 ,...
        'xClean',[4,5,6],...
        'byFFT',0,...
        'HeartBeat',0);
    cd ../
end
%% cleaning heartbeat (5min per subject)


for subi=1:length(Sub)
    cd (Sub{subi})
    close all;
    clean=correctHB;
    saveas(1,'HBraw.fig')
    saveas(2,'HBmean.png')
    close all;
    rewrite_pdf(clean,[],[],'hb,xc,lf');
    cd ../
end


