function [data,report]=combineplanarYH(cfg,interp)
% here I combine the H and V channels of interp (output of ft_megplanar)
% without turning the data to allpositive. it is designed to keep alpha
% zigzags intact. I check correlation between dV and dH (see labels of interp)
% and power of each in foi, and decide whether to take only one of them or
% their sum. if they are negatively correlated I take dH-dV.
% cfg has to have:
% cfg.foi = 9:11; or such like
% cfg.method changes the way you decide which channel to keep, Horizontal
% Vertical H-V or H+V.
%    'maxPlane' will take H or V, whoever has more PSD.
%    'maxCmb'   will take H+V or H-V, whoever has more PSD.
%    'corr'     will take H+V or H-V, depending on the sign of their correlation.


% % it can also have cfg.favorFac=5; if you want to take one (H) if it is
% % greater than the other (V) 5 times.
% if ~isfield(cfg,'favorFac')
%     cfg.favorFac=5;
% end
data={};
data.label=interp.cfg.channel;
data.grad=interp.hdr.grad;
data.time=interp.time;
data.fsample=interp.fsample;
data.sampleinfi=interp.sampleinfo;
sampEnd=length(interp.trial{1,1});
report={'channel','PSD H','PSD V','PSD (H+V)','PSD (H-V)','corr(H,V)','choice','chosen PSD'};
for chani=1:length(data.label)
    rcoef=corr(interp.trial{1,1}(chani+248,:)',interp.trial{1,1}(chani,:)');
    fH=fftBasic(interp.trial{1,1}(chani,:),interp.fsample);
    f(1,1)=mean(abs(fH(1,cfg.foi)),2);
    fV=fftBasic(interp.trial{1,1}(chani+248,:),interp.fsample);
    f(1,2)=mean(abs(fV(1,cfg.foi)),2);
    cmbPos=interp.trial{1,1}(chani,:)+interp.trial{1,1}(chani+248,:);
    cmbNeg=interp.trial{1,1}(chani,:)-interp.trial{1,1}(chani+248,:);
    fP=fftBasic(cmbPos,interp.fsample);
    f(1,3)=mean(abs(fP(1,cfg.foi)),2);
    fN=fftBasic(cmbNeg,interp.fsample);
    f(1,4)=mean(abs(fN(1,cfg.foi)),2);
    %[~,maxi]=max(f);
    report{chani+1,1}=num2str(data.label{chani}); %#ok<AGROW>
    report{chani+1,2}=num2str(f(1,1));
    report{chani+1,3}=num2str(f(1,2));
    report{chani+1,4}=num2str(f(1,3));
    report{chani+1,5}=num2str(f(1,4));
    report{chani+1,6}=num2str(rcoef);
    %report{chani+1,7}=report{1,1+maxi};
    switch cfg.method
        case 'maxPlane'
            [~,maxi]=max(f(1:2));
            switch maxi
                case 1 % H channel
                    data.trial{1,1}(chani,1:sampEnd)=interp.trial{1,1}(chani,:);
                case 2 % V channel
                    data.trial{1,1}(chani,1:sampEnd)=interp.trial{1,1}(chani+248,:);
                    
            end
            report{chani+1,7}=report{1,1+maxi};
            report{chani+1,8}=num2str(f(maxi));
        case 'maxCmb'
            [~,maxi]=max(f(3:4));
            switch maxi
                case 1 % H+V
                    data.trial{1,1}(chani,1:sampEnd)=cmbPos;
                case 2 % H-V
                    data.trial{1,1}(chani,1:sampEnd)=cmbNeg;
            end
            report{chani+1,7}=report{1,3+maxi};
            report{chani+1,8}=num2str(f(2+maxi));
        case 'corr'
            if rcoef>0
                data.trial{1,1}(chani,1:sampEnd)=cmbPos;
                report{chani+1,7}=report{1,4};
                report{chani+1,8}=num2str(f(3));
            else
                data.trial{1,1}(chani,1:sampEnd)=cmbNeg;
                report{chani+1,7}=report{1,5};
                report{chani+1,8}=num2str(f(4));
            end
            
    end
end