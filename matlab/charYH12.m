
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem
bands={'Delta','Theta','Alpha','Beta','Gamma'};
conds={'closed','open','charisma','room','dull','silent'};
first=true;

[v1,info]=BrikLoad('/media/yuval/YuvalExtDrive/Data/Hilla_Rotem/Char_1/YH/dull_Beta_R+tlrc');
in=abs(v1(:,:,:))>0;
ini=[];
inj=[];
ink=[];
for ki=1:size(in,3)
    [i,j,~]=find(in(:,:,ki));
    ini=[ini;i];
    inj=[inj;j];
    ink=[ink;ones(length(i),1)*ki];
end

OptTSOut.Scale = 1;
OptTSOut.verbose = 1;
OptTSOut.View = '+tlrc';

load audioDull
load audioChar


for bandi=[1,2,3,4,5]
    band=bands{bandi};
    for condi=[3,5]
        if condi==3
            aud=audioChar;
        else
            aud=audioDull;
        end
        cond=conds{condi};
        fn=[cond,'_',band,'_Raud'];
        for subi=1:40
            sub=['Char_',num2str(subi)];
            v=BrikLoad([sub,'/YH/',cond,'_',band,'+tlrc']);
            if subi==1
                V=v;
                disp(' ')
                disp([cond,' ',band,' sub:    '])
            else
                 V=V+v;
                 prog(subi)
            end
        end
        V=V./40;
        OptTSOut.Prefix = [conds{condi},'_',bands{bandi},'_Ravg'];
        R=zeros(size(V,1),size(V,2),size(V,3));
        P=ones(size(R));
        for voxi=1:length(ini)
            a=squeeze(V(ini(voxi),inj(voxi),ink(voxi),:));
            b=aud';
            a(a>median(a)*4)=nan;
            %b(b>median(b)*4)=nan;
            [R(ini(voxi),inj(voxi),ink(voxi)),P(ini(voxi),inj(voxi),ink(voxi))]=corr(a,b,'rows','pairwise');
        end
        R(P>0.05)=0;
        WriteBrik (R, info,OptTSOut);
    end
end





