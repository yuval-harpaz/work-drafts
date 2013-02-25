function amb20to25
cd /home/yuval/Data/amb
for subi=20:25
    sub=num2str(subi);
    cd(sub)
    cd 1
    trig=readTrig_BIU('c,rfhp1.0Hz,lp');
    trig=fixVisTrig(trig,1000);
    if max(unique(trig)==14)==1
        Dom1st=find(trig==12);
        DomRe=find(trig==14);
        DomUR=find(trig==16);
        Trig2mark('Dom1st',Dom1st,'DomRe',DomRe,'DomUR',DomUR);
        !mv MarkerFile.mrk Dom.mrk
    end
    if max(unique(trig)==24)==1
        Sub1st=find(trig==22);
        SubRe=find(trig==24);
        SubUR=find(trig==26);
        Trig2mark('Sub1st',Sub1st,'SubRe',SubRe,'SubUR',SubUR);
        !mv MarkerFile.mrk Sub.mrk
    end
    cd ../..
end