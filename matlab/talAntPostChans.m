
chan1=[177 127 97 99 101 134 184];
chan2=[123 63 21 23 25 47 103 163];
chan3=[121 61 19 4 2 12 49 105 137 186 220];
load ~/ft_BIU/matlab/files/LRpairs
for listi=1:2
    eval(['chan=chan',num2str(listi),';']);
    for chani=1:length(chan)
        chanr=LRpairs{find(ismember(LRpairs,['A',num2str(chan(chani))])),2};
        chans(1,chani)=str2num(chanr(2:end));
    end
    if listi==1
        eval('chan5=chans;');
    else
        eval('chan4=chans;');
    end
end
save /media/Elements/MEG/tal chan*


