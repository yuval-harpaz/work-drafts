function [left,right,inside]=findLRpairs(grid,vol)
left=find(grid.pos(:,2)>vol.o(2));

right=[];
for lefti=1:length(left)
    logi1=grid.pos(:,1)==grid.pos(left(lefti),1);
    logi2=abs(grid.pos(:,2)-(2*vol.o(2)-grid.pos(left(lefti),2)))<1e-10;
    logi3=grid.pos(:,3)==grid.pos(left(lefti),3);
    try
        right(lefti)=find((logi1+logi2+logi3)==3);
    catch
        error(['cannot find a right pair for grid index ',num2str(left(lefti))]);
    end
end
inside=false(size(grid.inside));
inside(left)=true;
inside(right)=true;
inside(~grid.inside)=false;