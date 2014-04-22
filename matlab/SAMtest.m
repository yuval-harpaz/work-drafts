cd Desktop/BIUdata/r1
[~,allInd]=voxIndex([0 0 0],[-12 12 -9 9 -2 15],0.5,1);
[~,grid]=headmodel_BIU(source);
grid2t(grid);
!mv pnt.txt SAM/pnt.txt
cd ..
!SAMwts -r r1 -d c,rfhp1.0Hz -m hfo -t pnt.txt -v
