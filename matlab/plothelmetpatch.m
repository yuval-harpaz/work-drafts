function fcs=plothelmetpatch(sns)
% plothelmetpatch(grad)
% choose edges to exclude
% plot3(sns.pnt(1:248,1),-sns.pnt(1:248,2),sns.pnt(1:248,3),'ko','markerfacecolor','k')
% C=convhulln(sns.pnt(1:248,:));
% hold on;
% for i = 1:size(C,1),  j = C(i,[1 2 3 1]); patch(sns.pnt(j,1),sns.pnt(j,2),sns.pnt(j,3),rand,'FaceAlpha',0.6); end;
% view(3), axis equal off tight vis3d; camzoom(1.2)
% colormap(spring)
% rotate3d on


X=sns.pnt;
X(:,2)=X(:,2);
figure;
plot3(sns.pnt(1:248,1),sns.pnt(1:248,2),sns.pnt(1:248,3),'o')
hold on;
C=convhulln(X(1:248,:));
for i = 1:size(C,1),  j = C(i,[1 2 3 1]); patch(sns.pnt(j,1),-sns.pnt(j,2),sns.pnt(j,3),rand,'FaceAlpha',0.6); end;
view(3), axis equal tight vis3d; camzoom(1.2)
colormap(spring);

for i=1:248, text(sns.pnt(i,1), -sns.pnt(i,2), sns.pnt(i,3), num2str(i)); end
edgelabels=[121:124,150:152,177,195,229:248];
for seni=1:length(edgelabels)
    edgesn(seni,1)=find(strcmp(['A',num2str(edgelabels(seni))],sns.label));
end
%edgesn=[226;156;93;229;147;117;183;181;11;47;121;82;175;37;67;
todel=[];
for i=1:length(C); if (~isempty(find(edgesn==C(i,1))) & ~isempty(find(edgesn==C(i,2))) & ~isempty(find(edgesn==C(i,3)))) todel=[todel i]; end
end;
for i=1:numel(todel), C(todel(i),:)=[0 0 0]; end


cf=find(C(:,1));fa=C(cf,:);
fcs=fa;
end