function [results,subjects]=aliceTablesC
exps={'AviBP','AviMa','Hyp','Tuv','alice','tal'};
subjects={};
subCount=0;
resLine=0;
conds={'Open','Closed'};
results=[];
load LRpairs;
anterior = {'A54', 'A55', 'A81', 'A82', 'A83', 'A112', 'A113', 'A114', 'A115', 'A144', 'A145', 'A146', 'A171', 'A172', 'A173', 'A174', 'A193', 'A209', 'A210', 'A211', 'A227', 'A244', 'A245', 'A246', 'A247'};
% anterior = {'A54', 'A55', 'A81', 'A82', 'A83', 'A112', 'A113', 'A114', 'A115', 'A144', 'A145', 'A146', 'A171', 'A172', 'A173', 'A174', 'A175', 'A193', 'A194', 'A209', 'A210', 'A211', 'A227', 'A228', 'A244', 'A245', 'A246', 'A247', 'A248'};
posterior =  {'A51', 'A52', 'A77', 'A78', 'A79', 'A107', 'A108', 'A109', 'A110', 'A139', 'A140', 'A141', 'A142', 'A167', 'A168', 'A169', 'A170', 'A188', 'A189', 'A190', 'A191', 'A206', 'A207', 'A208', 'A225'};
freqs=[6 9 10 11 12 15];
for expi=1:6
    cd /home/yuval/Copy/MEGdata/alpha
    cd(exps{expi})
    load subs.mat
    disp(subs{1});
    for subi=1:length(subs)
        resLine=resLine+1;
        subCount=subCount+1;
        subjects{subCount}=subs{subi};
        for condi=1:2
            if exist([conds{condi},'.mat'],'file')
                load (conds{condi})
                eval(['gav=',conds{condi},';'])
                if subi==1;
                    freqi=[nearest(gav.freq,6),nearest(gav.freq,9),nearest(gav.freq,10),nearest(gav.freq,11),nearest(gav.freq,12),nearest(gav.freq,15)];
                    [~,aRi]=ismember(anterior,gav.label);
                    [~,pRi]=ismember(posterior,gav.label);
                    aCnt=0;
                    pCnt=0;
                    for pairi=1:length(LRpairs)
                        chAb=0;
                        [~,chAb]=ismember(LRpairs{pairi,2},anterior);
                        if chAb>0
                            aCnt=aCnt+1;
                            [~,aLi(aCnt)]=ismember(LRpairs{pairi,1},gav.label);
                        else
                            chPb=0;
                            [~,chPb]=ismember(LRpairs{pairi,2},posterior);
                            if chPb>0
                                pCnt=pCnt+1;
                                [~,pLi(pCnt)]=ismember(LRpairs{pairi,1},gav.label);
                            end
                        end
                    end
                    for pairi=1:length(LRpairs)
                        if ismember(LRpairs{pairi,1},gav.label) && ismember(LRpairs{pairi,2},gav.label)
                            pair(pairi)=true;
                        end
                    end
                    [~,Li]=ismember(LRpairs(find(pair),1),gav.label);
                    Li=Li(Li>0);
                    [~,Ri]=ismember(LRpairs(find(pair),2),gav.label);
                    Ri=Ri(Ri>0);
                end

                Ra=squeeze(mean(gav.powspctrm(subi,aRi,freqi),2))';
                Rp=squeeze(mean(gav.powspctrm(subi,pRi,freqi),2))';
                La=squeeze(mean(gav.powspctrm(subi,aLi,freqi),2))';
                Lp=squeeze(mean(gav.powspctrm(subi,pLi,freqi),2))';
                [maxpRa,maxi]=max(Ra);
                maxfRa=freqs(maxi);
                [maxpRp,maxi]=max(Rp);
                maxfRp=freqs(maxi);
                [maxpLa,maxi]=max(La);
                maxfLa=freqs(maxi);
                [maxpLp,maxi]=max(Lp);
                maxfLp=freqs(maxi);
                R=squeeze(mean(gav.powspctrm(subi,Ri,freqi),2))';
                L=squeeze(mean(gav.powspctrm(subi,Li,freqi),2))';
                [maxpR,maxi]=max(R);
                maxfR=freqs(maxi);
                [maxpL,maxi]=max(L);
                maxfL=freqs(maxi);
                
                if max([maxfL,maxfR,maxfRa,maxfRp,maxfLa,maxfLp])>12 || min([maxfL,maxfR,maxfRa,maxfRp,maxfLa,maxfLp])<9
                    figure;
                    subplot(3,2,1)
                    [maxpLa,maxi]=max(La(2:end-1));
                    maxfLa=freqs(maxi+1);
                    plot(freqs,La)
                    hold on
                    plot(maxfLa,maxpLa,'or')
                    subplot(3,2,2)
                    [maxpRa,maxi]=max(Ra(2:end-1));
                    maxfRa=freqs(maxi+1);
                    plot(freqs,Ra)
                    hold on
                    plot(maxfRa,maxpRa,'or')
                    subplot(3,2,3)
                    [maxpLp,maxi]=max(Lp(2:end-1));
                    maxfLp=freqs(maxi+1);
                    plot(freqs,Lp)
                    hold on
                    plot(maxfLp,maxpLp,'or')
                    subplot(3,2,4)
                    [maxpRp,maxi]=max(Rp(2:end-1));
                    maxfRp=freqs(maxi+1);
                    plot(freqs,Rp)
                    hold on
                    plot(maxfRp,maxpRp,'or')
                    subplot(3,2,5)
                    [maxpL,maxi]=max(L(2:end-1));
                    maxfL=freqs(maxi+1);
                    plot(freqs,L)
                    hold on
                    plot(maxfL,maxpL,'or')
                     subplot(3,2,6)
                    [maxpR,maxi]=max(R(2:end-1));
                    maxfR=freqs(maxi+1);
                    plot(freqs,R)
                    hold on
                    plot(maxfR,maxpR,'or')
                    title(subs{subi})
                    figure;
                    cfg=[];
                    cfg.layout='4D248.lay';
                    cfg.trials=subi;
                    cfg.xlim=[10 10];
                    cfg.interactive='yes';
                    ft_topoplotER(cfg,gav)
                    pause
                    close all
                end
                % 9Hz
                lineBL=0;
                if condi==2
                    lineBL=36;
                end
                results(resLine,lineBL+1)=mean(gav.powspctrm(subi,aLi,3));
                results(resLine,lineBL+2)=mean(gav.powspctrm(subi,pLi,3));
                results(resLine,lineBL+3)=mean(gav.powspctrm(subi,aRi,3));
                results(resLine,lineBL+4)=mean(gav.powspctrm(subi,pRi,3));
                results(resLine,lineBL+5)=mean(gav.powspctrm(subi,Li,3));
                results(resLine,lineBL+6)=mean(gav.powspctrm(subi,Ri,3));
                %10Hz
                results(resLine,lineBL+7)=mean(gav.powspctrm(subi,aLi,4));
                results(resLine,lineBL+8)=mean(gav.powspctrm(subi,pLi,4));
                results(resLine,lineBL+9)=mean(gav.powspctrm(subi,aRi,4));
                results(resLine,lineBL+10)=mean(gav.powspctrm(subi,pRi,4));
                results(resLine,lineBL+11)=mean(gav.powspctrm(subi,Li,4));
                results(resLine,lineBL+12)=mean(gav.powspctrm(subi,Ri,4));
                %11Hz
                results(resLine,lineBL+13)=mean(gav.powspctrm(subi,aLi,5));
                results(resLine,lineBL+14)=mean(gav.powspctrm(subi,pLi,5));
                results(resLine,lineBL+15)=mean(gav.powspctrm(subi,aRi,5));
                results(resLine,lineBL+16)=mean(gav.powspctrm(subi,pRi,5));
                results(resLine,lineBL+17)=mean(gav.powspctrm(subi,Li,5));
                results(resLine,lineBL+18)=mean(gav.powspctrm(subi,Ri,5));
                %12Hz
                results(resLine,lineBL+19)=mean(gav.powspctrm(subi,aLi,6));
                results(resLine,lineBL+20)=mean(gav.powspctrm(subi,pLi,6));
                results(resLine,lineBL+21)=mean(gav.powspctrm(subi,aRi,6));
                results(resLine,lineBL+22)=mean(gav.powspctrm(subi,pRi,6));
                results(resLine,lineBL+23)=mean(gav.powspctrm(subi,Li,6));
                results(resLine,lineBL+24)=mean(gav.powspctrm(subi,Ri,6));
                %max
                results(resLine,lineBL+25)=maxpLa;
                results(resLine,lineBL+26)=maxpLp;
                results(resLine,lineBL+27)=maxpRa;
                results(resLine,lineBL+28)=maxpRp;
                results(resLine,lineBL+29)=maxpL;
                results(resLine,lineBL+30)=maxpR;
                
                results(resLine,lineBL+31)=maxfLa;
                results(resLine,lineBL+32)=maxfLp;
                results(resLine,lineBL+33)=maxfRa;
                results(resLine,lineBL+34)=maxfRp;
                results(resLine,lineBL+35)=maxfL;
                results(resLine,lineBL+36)=maxfR;
                
            end
        end
    end
end
subjects=subjects';


