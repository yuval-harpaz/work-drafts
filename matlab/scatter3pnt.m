function scatter3pnt(pnt,S,C)
%SCATTER3PNT(XYZ,S,C)
%give it a nx3 matrix and it will plot3
x=pnt(:,1);
y=pnt(:,2);
z=pnt(:,3);

try
    if isempty(S)
        S=25;
    end
catch
    S=25;
end
if exist('C','var')
    args={C,'filled'};
else
    args='filled';
end

try
    scatter3(x,y,z,S,args{:})
catch
    scatter3(x,y,z,S,args)
end
view([-90,90])
maxrange=max([range(x),range(y),range(z)]);
midsize=maxrange*0.6;
xlim([mean(x)-midsize,mean(x)+midsize])
ylim([mean(y)-midsize,mean(y)+midsize])
zlim([mean(z)-midsize,mean(z)+midsize])
axis vis3d
if exist('C','var')
    if ~ischar(C)
        cm=colormap;
        colorbar
        colormap(cm(1:end-7,:))
    end
end
rotate3d