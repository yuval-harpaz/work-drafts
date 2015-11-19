function charYH7(cond,band)

bands={'Delta','Theta','Alpha','Beta','Gamma'};
conds={'closed','open','charisma','room','dull','silent'};
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem
[~,bandi]=ismember(band,bands);
[~,condi]=ismember(cond,conds);

%% average power per condition per band
str='3dttest++ -set2';
for subi=1:40
    str=[str,' Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'_R+tlrc'];
end
[~,w]=afnix(str)
varA=[conds{condi},'_',bands{bandi},'_R+tlrc'];
permuteBriks(varA,[],'Char_',[],[],0.01);
