cd /media/Elements/MEG/talResults/pow

d=dir;
for i=4:32
    name=d(i,1).name
    varName=name(1:end-4);
    load(name)
    eval(['pow=',varName,';'])
    for subi=1:size(pow.powspctrm,1)
        for freqi=1:100
            pow.powspctrm(subi,:,freqi)=pow.powspctrm(subi,:,freqi)./max(squeeze(pow.powspctrm(subi,:,freqi)));
        end
    end
    eval([varName,'=pow;'])
    save(['norm/',varName],varName)
end

cd norm
load LRpairs
for i=4:32
    name=d(i,1).name
    varName=name(1:end-4);
    load(name)
    eval(['pow=',varName,';'])
    psm=zeros(size(pow.powspctrm));
    for pairi=1:115
        [Lmem,Li]=ismember(LRpairs(pairi,1),pow.label);
        [Rmem,Ri]=ismember(LRpairs(pairi,2),pow.label);
        if Lmem && Rmem
            psm(:,Li,:)=pow.powspctrm(:,Li,:)-pow.powspctrm(:,Ri,:);
            psm(:,Ri,:)=pow.powspctrm(:,Ri,:)-pow.powspctrm(:,Li,:);
        end
    end
    pow.powspctrm=psm;
    eval([varName,'=pow;'])
    save(['dif/',varName],varName)
end