function charYH6

bands={'Delta','Theta','Alpha','Beta','Gamma'};
conds={'closed','open','charisma','room','dull','silent'};
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem


%% average power per condition per band
for condi=1:6
    for bandi=1:5
        for subi=1:40
            V=BrikLoad(['Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'+tlrc']);
            eval(['V',num2str(subi),'=V;'])
            if condi==1 && bandi==1 && subi==1
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
                in=V1(:,:,:,1)>0;
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
        end
        clear V
        
        %[ini,inj,v]=find(in);
        h = waitbar(0,'SUB 1');
        for subi=1:40
            if ~exist(['Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'_R+tlrc.BRIK'],'file')
                R=zeros(size(in));
                count=0;
                for subj=1:40
                    if subi~=subj
                        for voxi=1:length(ini)
                            a=squeeze(eval(['V',num2str(subi),'(ini(voxi),inj(voxi),ink(voxi),:);']));
                            b=squeeze(eval(['V',num2str(subj),'(ini(voxi),inj(voxi),ink(voxi),:);']));
                            a(a>median(a)*4)=nan;
                            b(b>median(b)*4)=nan;
                            R(ini(voxi),inj(voxi),ink(voxi))=R(ini(voxi),inj(voxi),ink(voxi))+corr(a,b,'rows','pairwise');
                        end
                        count=count+1;
                    end
                    prog(subj)
                end
                if count~=39
                    error('wrong count of subs')
                    count %#ok<UNRCH>
                end
                R=R./count;
                if exist(['Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'_R+tlrc.BRIK'],'file')
                    [~,w]=unix(['rm ','Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'_R+*'])
                end
                OptTSOut.Prefix = ['Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'_R'];
                OptTSOut.Scale = 1;
                OptTSOut.verbose = 1;
                OptTSOut.View = '+tlrc';
                WriteBrik (R, info,OptTSOut);
            end
            waitbar(subi/40,h,[conds{condi},', ',bands{bandi}]);
        end
    end
end
disp('')