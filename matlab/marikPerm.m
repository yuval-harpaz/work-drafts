function marikPerm
% cd ~/Data/epilepsy/g2/movies/
% %vox=[17 24 17];
% cond={'seg','sw','_'};
% cd 
% [V,info]=BrikLoad('/home/yuval/Data/epilepsy/g2/avg/common+orig');
% OptTSOut.Scale = 1;
% OptTSOut.verbose = 1;
% for condi=1:3
%     for runi=1:3
%         run=num2str(runi);
%         V=BrikLoad(['g2',cond{condi},run,'+orig']);
%         full=V(:,:,:,1);
%         full=full(:);
%         full=full>0;
%         full=reshape(full,49,37,35);
%         Vt=zeros(size(full));
%         for i=1:size(V,1)
%             for j=1:size(V,2)
%                 for k=1:size(V,3)
%                     if full(i,j,k)
%                         [~,p]=ttest2(V(i,j,k,31:46),V(i,j,k,1:30),[],'right');
%                         Vt(i,j,k)=1-p;
%                     end
%                 end
%             end
%         end                            
%         if condi==3
%             OptTSOut.Prefix =['all',run,'g2t'];
%         else
%             OptTSOut.Prefix =[cond{condi},run,'g2t'];
%         end
%         WriteBrik (Vt, info,OptTSOut);
%         !mv *g2t* t/
%     end
% end

% cd /home/yuval/Data/epilepsy/meanAbs/Movies
% %vox=[17 24 17];
% cond={'seg','sw','all'};
% cd 
% [V,info]=BrikLoad('/home/yuval/Data/epilepsy/g2/avg/common+orig');
% OptTSOut.Scale = 1;
% OptTSOut.verbose = 1;
% for condi=1:3
%     for runi=1:3
%         run=num2str(runi);
%         V=BrikLoad([cond{condi},run,'+orig']);
%         full=V(:,:,:,1);
%         full=full(:);
%         full=full>0;
%         full=reshape(full,49,37,35);
%         Vt=zeros(size(full));
%         for i=1:size(V,1)
%             for j=1:size(V,2)
%                 for k=1:size(V,3)
%                     if full(i,j,k)
%                         [~,p]=ttest2(V(i,j,k,31:46),V(i,j,k,1:30),[],'right');
%                         Vt(i,j,k)=1-p;
%                     end
%                 end
%             end
%         end                            
%         
%         OptTSOut.Prefix =[cond{condi},run,'t'];
%         WriteBrik (Vt, info,OptTSOut);
%         !mv *t+* t/
%     end
% end

cd /home/yuval/Data/epilepsy/meanAbs/Movies
%vox=[17 24 17];
cond={'seg','sw','all'};
% cd 


for permi=1:500
    % choose the random ictal time points
    rnd=rand(1,46);
    [~,rnd]=sort(rand(1,46));
    rndI=rnd(1:16);
    rndPI=rnd(17:end);
    for condi=1:3
        for runi=1:3
            run=num2str(runi);
            V=BrikLoad([cond{condi},run,'+orig']);
            full=V(:,:,:,1);
            full=full(:);
            full=full>0;
            full=reshape(full,49,37,35);
            Vt=zeros(size(full));
            for i=1:size(V,1)
                for j=1:size(V,2)
                    for k=1:size(V,3)
                        if full(i,j,k)
                            [~,p]=ttest2(V(i,j,k,rndI),V(i,j,k,rndPI),[],'right');
                            Vt(i,j,k)=1-p;
                        end
                    end
                end
            end
            Vt=Vt(:);
            pMax(permi,condi,runi)=max(Vt);
            
        end
    end
    permi
end
save pMax pMax
OptTSOut.Scale = 1;
OptTSOut.verbose = 1;
%OptTSOut.Prefix ='prm';
OptTSOut.Prefix =[cond{condi},run,'prm'];
for condi=1:3
    for runi=1:3
        [V,info]=BrikLoad(['t/',cond{condi},run,'t+orig']);
        V=V>critP;
        WriteBrik (V, info,OptTSOut);
    end
end
% !mv *t+* t/
%cP=[num2str(critP*1000000),'/1000000'];




