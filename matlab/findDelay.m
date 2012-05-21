function [onsetDelay,onsetStd]=findDelay(fileName)
% looks for the difference between E' and visual triggers
hdr=ft_read_header(fileName);
trig=readTrig_BIU(fileName);
vis=fixVisTrig(trig,203);
trigc=clearTrig(trig);
visi=find(vis);
trigci=find(trigc);
dif=visi-trigci;
onsetDelay=mean(dif).*1000/hdr.Fs;
onsetStd=std(dif).*1000/hdr.Fs;
close all
end