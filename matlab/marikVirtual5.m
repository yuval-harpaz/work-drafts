%% make subject list
cd /home/yuval/Data/marik/som2

[pnt,lf,vol]=sphereGrid;
xyz=pnt(1,:);


%% cleaning line frequency (25min per subject)

for runi=1:3
    cd (num2str(runi))
    close all;
    correctLF;
    saveas(1,'lf.png')
    close
    cd ../
end

