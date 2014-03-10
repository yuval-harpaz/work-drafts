cd /media/Elements/quadaqua
load subs
runs={'a','b'};
close all
for subi=1:8
    cd(subs{subi})
    for runi=1:2
        cd (runs{runi})
        if subi==2 && runi==1
            for ri=1:2
                cd(num2str(ri))
                if ~exist('lf,hb_c,rfhp0.1Hz','file')
                    disp(subs{subi});
                    trig=bitand(uint16(readTrig_BIU('c,rfhp0.1Hz')),256);
                    dataLF=correctLF('c,rfhp0.1Hz',[],trig);
                    saveas(1,'lf.png')
                    close
                    dataHB=correctHB(dataLF,1017.25);
                    saveas(1,'hb.fig')
                    rewrite_pdf(dataHB,[],'c,rfhp0.1Hz','lf,hb')
                    close
                end
                if ~exist('xc,lf,hb_c,rfhp0.1Hz','file')
                    p=pdf4D('lf,hb_c,rfhp0.1Hz')
                    createCleanFile(p,'lf,hb_c,rfhp0.1Hz','byLF',0 ,'xClean',[4,5,6],'byFFT',0,'HeartBeat',0);
                end
                cd ..
            end
        else
            if ~exist('lf,hb_c,rfhp0.1Hz','file')
                disp(subs{subi});
                trig=bitand(uint16(readTrig_BIU('c,rfhp0.1Hz')),256);
                dataLF=correctLF('c,rfhp0.1Hz',[],trig);
                saveas(1,'lf.png')
                close
                dataHB=correctHB(dataLF,1017.25);
                saveas(1,'hb.fig')
                rewrite_pdf(dataHB,[],'c,rfhp0.1Hz','lf,hb')
                close
            end
            if ~exist('xc,lf,hb_c,rfhp0.1Hz','file')
                p=pdf4D('lf,hb_c,rfhp0.1Hz')
                createCleanFile(p,'lf,hb_c,rfhp0.1Hz','byLF',0 ,'xClean',[4,5,6],'byFFT',0,'HeartBeat',0);
            end
        end
        cd ..
    end
    cd ..
end