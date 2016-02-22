%% connectomeDB

cd /media/yuval/win_disk/Data/connectomeDB/MEG
load Subs
fn='c,rfDC';
for subi=[1,3:10]
    cd /media/yuval/win_disk/Data/connectomeDB/MEG
    cd(num2str(Subs(subi)))
    cd unprocessed/MEG/3-Restin/4D/
    [~,HBtimesE]=correctHB(fn,[],[],'E2');
    [~,HBtimes]=correctHB(fn);
    title(num2str(Subs(subi)))
    if length(HBtimes)==length(HBtimesE)
        means(subi)=mean(HBtimesE-HBtimes)*1000;
        SDs(subi)=std(HBtimesE-HBtimes)*1000;
        ranges(subi,1:2)=minmax((HBtimesE-HBtimes)*1000);
    else
        disp([num2str(subi),' no HB fit'])
    end
end
cd /media/yuval/win_disk/Data/connectomeDB/MEG
save E_Mstats means SDs ranges
