function charArb1


%% make subject list
if exist('/media/My Passport/Hila&Rotem')
    cd ('/media/My Passport/Hila&Rotem')
else
    [~,w]=unix('echo $USER');
    cd (['/media/',w(1:end-1),'/My Passport/Hila&Rotem'])
end
load Sub



timewin=1;
sampwin=round(1017.25*timewin);
ovrlp=round(1017.25*timewin/2);
%% cleaning line frequency (25min per subject)
source='hb,xc,lf_c,rfhp0.1Hz';
trigVal=[202 204 220 230 240 250];
conds={'closed','open','charism','room','dull','silent'};

for subi=1:length(Sub)
    TRL=[];
    cd (Sub{subi})
    if exist(source,'file') && exist('lf_c,rfhp0.1Hz','file')
        !rm xc,lf_c,rfhp0.1Hz
        !rm lf_c,rfhp0.1Hz
    end
    if ~exist('data.mat','file')
        disp(['read trig for ',Sub{subi}])
        trig=readTrig_BIU(source);
        trig=bitset(uint16(trig),12,0);
        trig=bitset(uint16(trig),9,0);
        trigSamp=trigOnset(trig);
        trigSamp(2,:)=trig(trigSamp);
        for condi=1:length(trigVal)
            condSamp=trigSamp(1,find(trigSamp(2,:)==trigVal(condi)));
            if length(condSamp)==1
                condSamp(2)=condSamp(1)+round(1017.25*121);
            end
            trl1=condSamp(1):sampwin:condSamp(2);
            trl2=(condSamp(1)+ovrlp):sampwin:condSamp(2);
            
            trl=sort([trl1';trl2']);
            trl(:,2)=trl+sampwin-1;
            trl(:,3)=0;
            trl(:,4)=trigVal(condi);
            TRL((size(TRL,1)+1):(size(TRL,1)+size(trl,1)),1:4)=trl;
        end
        save data TRL
        clear TRL
    end
    cd ../
end




