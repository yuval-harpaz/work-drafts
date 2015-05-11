%% make subject list
cd /home/yuval/Data/marik/som2/1

[pnt,lf,vol]=sphereGrid;
pnt_complex=findPerpendicular(pnt);
dip1=(pnt_complex(1,:,2)-pnt_complex(1,:,1))*lf.leadfield{1}';
dip2=(pnt_complex(1,:,3)-pnt_complex(1,:,1))*lf.leadfield{1}';
dipR=(pnt_complex(1,:,4)-pnt_complex(1,:,1))*lf.leadfield{1}';
cfg=[];
cfg.zlim=[-max(abs([dip1,dip2,dipR])) max(abs([dip1,dip2,dipR]))];
figure;
topoplot248(dip1,cfg)
figure;
topoplot248(dip2,cfg)
figure;
topoplot248(dipR,cfg)
%% cleaning line frequency (25min per subject)

for runi=1:3
    cd (num2str(runi))
    close all;
    correctLF;
    saveas(1,'lf.png')
    close
    cd ../
end

