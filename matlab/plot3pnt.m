function plot3pnt(pnt,arg4)
%give it a nx3 matrix and it will plot3
x=pnt(:,1);
y=pnt(:,2);
z=pnt(:,3);
if exist('arg4','var')
    plot3(x,y,z,arg4)
else
    plot3(x,y,z)
end

