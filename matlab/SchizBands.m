function SchizBands
bands=[1 4;5 8;9 12;13 19;20 25;26 70;13 25];
cd /media/yuval/Elements/SchizoRestMaor
load Subs
load distances;
tooClose=distances<16;
scCount=0;
sc=false;
coCount=0;
scLabel={};
coLabel={};
[~,ind]=ismember({'A1','A2','A3','A4','A5','A6','A7','A8','A9','A10','A11','A12','A13','A14','A15','A16','A17','A18','A19','A20','A21','A22','A23','A24','A25','A26','A27','A28','A29','A30','A31','A32','A33','A34','A35','A36','A37','A38','A39','A40','A41','A42','A43','A44','A45','A46','A47','A48','A49','A50','A51','A52','A53','A54','A55','A56','A57','A58','A59','A60','A61','A62','A63','A64','A65','A66','A67','A68','A69','A70','A71','A72','A73','A74','A75','A76','A77','A78','A79','A80','A81','A82','A83','A84','A85','A86','A87','A88','A89','A90','A91','A92','A93','A94','A95','A96','A97','A98','A99','A100','A101','A102','A103','A104','A105','A106','A107','A108','A109','A110','A111','A112','A113','A114','A115','A116','A117','A118','A119','A120','A121','A122','A123','A124','A125','A126','A127','A128','A129','A130','A131','A132','A133','A134','A135','A136','A137','A138','A139','A140','A141','A142','A143','A144','A145','A146','A147','A148','A149','A150','A151','A152','A153','A154','A155','A156','A157','A158','A159','A160','A161','A162','A163','A164','A165','A166','A167','A168','A169','A170','A171','A172','A173','A174','A175','A176','A177','A178','A179','A180','A181','A182','A183','A184','A185','A186','A187','A188','A189','A190','A191','A192','A193','A194','A195','A196','A197','A198','A199','A200','A201','A202','A203','A204','A205','A206','A207','A208','A209','A210','A211','A212','A213','A214','A215','A216','A217','A218','A219','A220','A221','A222','A223','A224','A225','A226','A227','A228','A229','A230','A231','A232','A233','A234','A235','A236','A237','A238','A239','A240','A241','A242','A243','A244','A245','A246','A247','A248'},{'A22';'A2';'A104';'A241';'A138';'A214';'A71';'A26';'A93';'A39';'A125';'A20';'A65';'A9';'A8';'A95';'A114';'A175';'A16';'A228';'A35';'A191';'A37';'A170';'A207';'A112';'A224';'A82';'A238';'A202';'A220';'A28';'A239';'A13';'A165';'A204';'A233';'A98';'A25';'A70';'A72';'A11';'A47';'A160';'A64';'A3';'A177';'A63';'A155';'A10';'A127';'A67';'A115';'A247';'A174';'A194';'A5';'A242';'A176';'A78';'A168';'A31';'A223';'A245';'A219';'A12';'A186';'A105';'A222';'A76';'A50';'A188';'A231';'A45';'A180';'A99';'A234';'A215';'A235';'A181';'A38';'A230';'A91';'A212';'A24';'A66';'A42';'A96';'A57';'A86';'A56';'A116';'A151';'A141';'A120';'A189';'A80';'A210';'A143';'A113';'A27';'A137';'A135';'A167';'A75';'A240';'A206';'A107';'A130';'A100';'A43';'A200';'A102';'A132';'A183';'A199';'A122';'A19';'A62';'A21';'A229';'A84';'A213';'A55';'A32';'A85';'A146';'A58';'A60';'A88';'A79';'A169';'A54';'A203';'A145';'A103';'A163';'A139';'A49';'A166';'A156';'A128';'A68';'A159';'A236';'A161';'A121';'A4';'A61';'A6';'A126';'A14';'A94';'A15';'A193';'A150';'A227';'A59';'A36';'A225';'A195';'A30';'A109';'A172';'A108';'A81';'A171';'A218';'A173';'A201';'A74';'A29';'A164';'A205';'A232';'A69';'A157';'A97';'A217';'A101';'A124';'A40';'A123';'A153';'A178';'A1';'A179';'A33';'A147';'A117';'A148';'A87';'A89';'A243';'A119';'A52';'A142';'A211';'A190';'A53';'A192';'A73';'A226';'A136';'A184';'A51';'A237';'A77';'A129';'A131';'A198';'A197';'A182';'A46';'A92';'A41';'A90';'A7';'A23';'A83';'A154';'A34';'A17';'A18';'A248';'A149';'A118';'A208';'A152';'A140';'A144';'A209';'A110';'A111';'A244';'A185';'A246';'A162';'A106';'A187';'A48';'A221';'A196';'A133';'A158';'A44';'A134';'A216'});
cohCo=zeros(248,248,1,1);
for subi=1:length(Subs)
    if strcmp(Subs{subi,3},'v')
        sub=Subs{subi,1};
        cd(sub)
        clear cond*
        try
            load freq
            load coh
            load cohLR
            for i=1:248
                for j=1:248
                    Coh(i,j,1:70)=coh.cohspctrm(ind(i),ind(j),:);
                end
            end
            
            % %             coh1to4=cohBand(cohLR,1:4,Li,Ri);
            % %             coh5to8=cohBand(cohLR,5:8,Li,Ri);
            % %             coh9to12=cohBand(cohLR,9:12,Li,Ri);
            % %             coh13to19=cohBand(cohLR,13:19,Li,Ri);
            % %             coh20to25=cohBand(cohLR,20:25,Li,Ri);
            % %             coh26to70=cohBand(cohLR,26:70,Li,Ri);
            %             coh=cohBand(cohLR,Li,Ri);
            if strcmp(Subs{subi,2}(1),'S')
                sc=true;
                scCount=scCount+1;
                scLabel{scCount}=sub;
            else
                sc=false;
                coCount=coCount+1;
                coLabel{coCount}=sub;
            end
            for bandi=1:size(bands,1)
                band1=num2str(bands(bandi,1));
                band2=num2str(bands(bandi,2));
                cohTemp=mean(Coh(:,:,bands(bandi,1):bands(bandi,2)),3);
                powTemp=mean(mean(abs(freq.fourierspctrm(:,:,bands(bandi,1):bands(bandi,2))),3),1);
                cohlrTemp=mean(cohLR(:,bands(bandi,1):bands(bandi,2)),2);
                if sc
                    eval(['cohSc',band1,'to',band2,'(1:248,1:248,scCount)=cohTemp;']);
                    eval(['powSc',band1,'to',band2,'(1:248,scCount)=powTemp;']);
                    eval(['cohlrSc',band1,'to',band2,'(1:248,scCount)=cohlrTemp;']);
                    
                else
                    
                    
                    eval(['cohCo',band1,'to',band2,'(1:248,1:248,coCount)=cohTemp;']);
                    eval(['powCo',band1,'to',band2,'(1:248,coCount)=powTemp;']);
                    eval(['cohlrCo',band1,'to',band2,'(1:248,coCount)=cohlrTemp;']);
                    
                    
                end
                
            end
            disp(['done ',sub]);
        catch
            disp([sub,' had no split cond'])
        end
        cd ../
    end
end
cd /media/yuval/Elements/SchizoRestMaor
save bands *to* bands *Label
disp('finish');
% function cohFreq=cohBand(cohLR,Li,Ri)
% %coh=mean(cohLR.cohspctrm(:,9:12),2);
% cohFreq=ones(248,70);
% cohFreq(Ri,:)=cohLR.cohspctrm;
% cohFreq(Li,:)=cohLR.cohspctrm;
% 
%
% [~,chani]=ismember('A158',cond204.label);
% [~,p]=ttest2(fSc(chani,:),fCo(chani,:))
%
% [~,p]=ttest2(fSc',fCo');
% cfg=[];
% cfg.highlight='labels';
% cfg.highlightchannel=find(p<0.05);
% cfg.zlim=[0 5e-14];
% figure;topoplot248(mean(fSc,2),cfg);title('Sciz')
% figure;topoplot248(mean(fCo,2),cfg);title('Cont')
% [~,p]=ttest2(cohSc',cohCo');
% cfg=[];
% cfg.highlight='labels';
% cfg.highlightchannel=find(p<0.05);
% cfg.zlim=[0 0.75];
% figure;topoplot248(mean(cohSc,2),cfg);title('Sciz')
% figure;topoplot248(mean(cohCo,2),cfg);title('Cont')
