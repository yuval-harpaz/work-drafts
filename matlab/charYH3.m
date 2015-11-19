function R=charYH3(freqMethod, chanMethod)
% chanMethod='max'; % 'mean' 'min'
% freqMethod = 'max'; % 'mean'
bands={'Delta','Theta','Alpha','Beta','Gamma'};
freqs=[1,4;4,8;8,13;13,25;25,40];
trigVal=[202 204 220 230 240 250;202 204 240 230 220 250];
conds={'closed','open','charisma','room','dull','silent'};
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem

%% average power per condition per band    

for condi=1:6
    for bandi=1:5
        for subi=1:40
            load(['Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'_',freqMethod,'_',chanMethod])
            if subi==1
                Pow=nan(40,size(pow,2));
            end
            Pow(subi,:)=pow;
            PowNan=Pow;
            PowNan(Pow>(median(Pow(:))*4))=nan;
%             figure;
%             plot(Pow')
%             hold on
%             plot(PowNan','k')
%             line([1,243],[median(Pow(:))*4,median(Pow(:))*4],'color','m')
        end
        rr=corr(PowNan','rows','pairwise');
        rr(logical(eye(40)))=nan;
        R(1:40,condi,bandi)=nanmean(rr);
    end
end
save (['R_',freqMethod,'_',chanMethod], 'R')

bandi=1:5;

for bi=1:length(bandi)
    bars=mean(R(:,:,bandi(bi)),1);
    err=std(R(:,:,bandi(bi))./sqrt(40));
    fig1=figure;
    hold all;
    bar(bars,'w');
    errorbar(bars,err,'k','linestyle','none')
    bar(bars,'w');
    bar(3,bars(3),'b');
    bar(5,bars(5),'r');
    title(bands{bandi(bi)})
    set(gca,'XTick',1:6);
    set(gca,'XTickLabel',conds);
    hight=(err(5)+bars(5))*1.3;
    tall=0.95*hight;
    line([3,3,5,5],[tall,hight,hight,tall],'color','k','lineWidth',2);
    [~,p]=ttest(R(:,3,bandi(bi)),R(:,5,bandi(bi)))
    ylim([0,max([max(bars+err),hight*1.4])]);
    annotation(fig1,'textbox',...
        [0.5 0.7 0.085 0.05],...
        'String',{['p=',num2str(p)]},...
        'FitBoxToText','off',...
        'LineStyle','none');
end
