exp={'alice','AviMa','Hyp','tal','Tuv'};
clear sub*
cd /home/yuval/Copy/MEGdata/alpha/tal
load Open
%label=Open.label;
Open.powspctrm=zeros(size(Open.powspctrm(1,:,:)));
OpenNeg=rmfield(Open,'cfg');
ClosedNeg=Open;
N=0;
Nneg=0;
NO=0;
NOneg=0;
NC=0;
NCneg=0;
for expi=1:5
    op=false;
    cl=false;
    cd /home/yuval/Copy/MEGdata/alpha
    cd (exp{expi})
    load headPos
    N=N+size(o,1);
    if exist('Open.mat','file')
        op=true;
        NO= NO+size(o,1);
        load Open
        [~,chani]=ismember(OpenNeg.label,Open.label);
        chani=chani(chani>0);
    end
    if exist('Closed.mat','file')
        cl=true;
        NC= NC+size(o,1);
        load Closed
        [~,chani]=ismember(ClosedNeg.label,Closed.label);
        chani=chani(chani>0);
    end
    neg=find(o(:,2)<=0.001);
    if ~isempty(neg)
        disp(length(neg))
        for negi=1:length(neg)
            if op
                eval(['OpenNeg.powspctrm(',num2str(NOneg+negi),',:,:)=Open.powspctrm(',num2str(neg(negi)),',chani,:)']);
            end
            if cl
                eval(['ClosedNeg.powspctrm(',num2str(NCneg+negi),',:,:)=Closed.powspctrm(',num2str(neg(negi)),',chani,:)']);
            end
        end
        Nneg=Nneg+length(neg);
        if op
            NOneg=NOneg+length(neg);
        end
        if cl
            NCneg=NCneg+length(neg);
        end
    end
end
cd /home/yuval/Copy/MEGdata/alpha
save leftHeadPosition ClosedNeg OpenNeg