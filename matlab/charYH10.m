function charYH10

bands={'Delta','Theta','Alpha','Beta','Gamma'};
conds={'closed','open','charisma','room','dull','silent'};
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem
load audioDull
load audioChar

%% average power per condition per band
h = waitbar(0,'SUB 1');
for condi=[3,5]
    if condi==3
        aud=audioChar;
    else
        aud=audioDull;
    end
    for bandi=[1,2,3,5]
        for subi=1:40
            V=BrikLoad(['Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'+tlrc']);
            if condi==3 && subi==1 % && bandi==1
                [~,info]=BrikLoad(['Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'+tlrc']);
                info.DATASET_RANK(2)=1;
                info.BRICK_TYPES=3*ones(1,1);
                info.RootName = '';
                info.BRICK_STATS = [];
                info.BRICK_FLOAT_FACS = [];
                info.IDCODE_STRING = '';
                info.TAXIS_NUMS(1)=1;
                info.BRICK_LABS='R';
                info.BRICK_KEYWORDS='~';
                in=V(:,:,:,1)>0;
                ini=[];
                inj=[];
                ink=[];
                for ki=1:size(in,3)
                    [i,j,~]=find(in(:,:,ki));
                    ini=[ini;i];
                    inj=[inj;j];
                    ink=[ink;ones(length(i),1)*ki];
                end
            end
            
            if ~exist(['Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'_Raud+tlrc.BRIK'],'file')
                R=zeros(size(in));
                for voxi=1:length(ini)
                    a=squeeze(V(ini(voxi),inj(voxi),ink(voxi),:));
                    b=aud';
                    a(a>median(a)*4)=nan;
                    %b(b>median(b)*4)=nan;
                    R(ini(voxi),inj(voxi),ink(voxi))=R(ini(voxi),inj(voxi),ink(voxi))+corr(a,b,'rows','pairwise');
                end
            end
%             if exist(['Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'_Raud+tlrc.BRIK'],'file')
%                 [~,w]=unix(['rm ','Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'_Raud+*'])
%             end
            OptTSOut.Prefix = ['Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'_Raud'];
            OptTSOut.Scale = 1;
            OptTSOut.verbose = 1;
            OptTSOut.View = '+tlrc';
            WriteBrik (R, info,OptTSOut);
            waitbar(subi/40,h,[conds{condi},', ',bands{bandi}]);
        end
    end
end
disp('')