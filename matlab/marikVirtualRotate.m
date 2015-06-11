clear
deg=10;
ang=deg2rad(deg);
R=[1,0,0;0,cos(ang),-sin(ang);0,sin(ang),cos(ang)];
pnt=[0;0;1]; % xyz of first point
pnt(:,2)=[0.1;0;1];
pnt(:,3)=[0;0.1;1];

for i=2:(360/deg)
    pnt(:,:,i)=R*pnt(:,:,i-1);
end
pntLoc=squeeze(pnt(:,1,:))';
pntDip1=squeeze(pnt(:,2,:))';
pntDip2=squeeze(pnt(:,3,:))';

R=[cos(ang),0,sin(ang);0,1,0;-sin(ang),0,cos(ang)];
len=size(pntLoc,1);
leni=len;
new=R*pntLoc';
new=new'
for i=2:(len/2)
    new=R*new';
    new=new'
    pntLoc(end:end+len-1,:)=new;
end



figure;
scatter3pnt(pntLoc,[],'k')
hold on
scatter3pnt(pntDip1,[],'b')
plot3pnt(pntDip2,'r.')
plot3pnt([0,0,0],'g.')

