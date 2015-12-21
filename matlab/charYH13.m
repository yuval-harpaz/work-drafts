function R=charYH13(chanMethod,freqMethod)
if ~existAndFull('chanMethod')
    chanMethod='max'; % 'mean' 'min'
end
if ~existAndFull('freqMethod')
    freqMethod = 'max'; % 'mean'
end
bands={'Delta','Theta','Alpha','Beta','Gamma'};
freqs=[1,4;4,8;8,13;13,25;25,40];
trigVal=[202 204 220 230 240 250;202 204 240 230 220 250];
conds={'closed','open','charisma','room','dull','silent'};
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem

%% average power per condition per band    
R=zeros(40,6,5);
for condi=1:6
    for bandi=1:5
        for subi=1:40
            load(['Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'_',freqMethod,'_',chanMethod])
            if subi==1
                Pow=nan(40,size(pow,2));
                segs=1:10:size(Pow,2)-19;
                segs(2,:)=segs+19;
            end
            
            PowNan=pow;
            PowNan(pow>(median(pow)*4))=nan;
            Pow(subi,:)=PowNan;
%             figure;
%             plot(Pow')
%             hold on
%             plot(PowNan','k')
%             line([1,243],[median(Pow(:))*4,median(Pow(:))*4],'color','m')
        end
        
        rr=corr(Pow','rows','pairwise');
        rr(logical(eye(40)))=nan;
        R(1:40,condi,bandi)=nanmean(rr);
        PSD(1:40,condi,bandi)=nanmean(Pow,2);
%         %seg
%         RR=[];
%         for seg10i=1:length(segs)
%             rr=corr(Pow(:,segs(1,seg10i):segs(2,seg10i))','rows','pairwise');
%             rr(logical(eye(40)))=nan;
%             rr=nanmean(rr);
% %             rG=find(rr'>R(:,condi,bandi));
% %             if ~isempty(rG)
%             RR(seg10i)=mean(rr);
%                 
% %             end
%         end
%         Rseg(condi,bandi)=max(RR);
        disp(['done ',conds{condi},' ',bands{bandi},' mean R = ',num2str(mean(R(:,condi,bandi)))]);
    end
    
end
% save (['R_',freqMethod,'_',chanMethod], 'R')
% save (['PSD_',freqMethod,'_',chanMethod], 'PSD')
bandi=1:5;

for bi=1:length(bandi)
    bars=mean(R(:,:,bandi(bi)),1);
    %bars=Rseg(:,bandi(bi));
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
    [~,p]=ttest(R(:,3,bandi(bi)),R(:,5,bandi(bi)));
    ylim([min([0,min(bars)]),max([max(bars+err),hight*1.4])]);
    annotation(fig1,'textbox',...
        [0.5 0.7 0.085 0.05],...
        'String',{['p=',num2str(p)]},...
        'FitBoxToText','off',...
        'LineStyle','none');
    
    bars=mean(PSD(:,:,bandi(bi)),1);
    %bars=Rseg(:,bandi(bi));
    err=std(PSD(:,:,bandi(bi))./sqrt(40));
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
    [~,p]=ttest(PSD(:,3,bandi(bi)),PSD(:,5,bandi(bi)));
    ylim([min([0,min(bars)]),max([max(bars+err),hight*1.4])]);
    annotation(fig1,'textbox',...
        [0.5 0.7 0.085 0.05],...
        'String',{['p=',num2str(p)]},...
        'FitBoxToText','off',...
        'LineStyle','none');
end
disp('done')
