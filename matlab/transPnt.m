function pntNew=transPnt(pntOld,M1)
pntOld=pntOld';
pntOld(4,:)=1;
pntNew = M1 * pntOld;
pntNew = pntNew(1:3,:)';