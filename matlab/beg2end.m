function [BEG END]=beg2end


source='rw_c,rfhp1.0Hz,lp';
trig=readTrig_BIU('rw_c,rfhp1.0Hz,lp');
trigC=clearTrig(trig);%DomBlock=find(trigC==14);
if exist('Dom.mrk','file')
    m1=[];
    m1(1,1)=max(find(trigC==14));
    m1(1,2)=max(find(trigC==16));
    END=max(max(m1));
    BEG=find(trigC==12,1);
else
    m1=[];
    m1(1,1)=max(find(trigC==24));
    m1(1,2)=max(find(trigC==26));
    END=max(max(m1));
    BEG=find(trigC==22,1);
end
end