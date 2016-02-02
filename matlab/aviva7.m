
bands={'theta','beta','gamma','gammah','gammahh'};

cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
load subCoor
load goodSubs
for bandi=1:length(bands)
    for subi=1:length(subCoor)
        cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
        sub=subCoor{subi,1};
        cd(sub);
        copyfile(['/media/yuval/YuvalExtDrive/Data/Aviva/MEG/',bands{bandi},'.param'],'./');
        %!cp /media/yuval/YuvalExtDrive/Data/Aviva/MEG/alpha.param ./
        if ~exist(['1/SAM/',bands{bandi},'.wts'],'file')
            [~,w]=unix(['SAMcov64 -r 1 -d xc,hb,lf_c,rfhp0.1Hz -m ',bands{bandi},' -v'])
        end
        if ~exist(['1/SAM/',bands{bandi},'.wts'],'file')
            [~,w]=unix(['SAMwts64 -r 1 -d xc,hb,lf_c,rfhp0.1Hz -m ',bands{bandi},' -c Alla -t pnt.txt -v'])
            [~,w]=unix(['mv 1/SAM/pnt.txt.wts 1/SAM/',bands{bandi},'.wts'])
        end
        if ~exist(['1/SAM/',bands{bandi},'N.wts'],'file')
            [~,w]=unix(['SAMNwts64 -r 1 -d xc,hb,lf_c,rfhp0.1Hz -m ',bands{bandi},' -c Alla -t pnt.txt -v'])
            [~,w]=unix(['mv 1/SAM/',bands{bandi},',pnt.txt.wts 1/SAM/',bands{bandi},'N.wts'])
        end
        disp(['XXXXXXXXXXXXXXX ',sub,' XXXXXXXXXXXXXX'])
    end
end
