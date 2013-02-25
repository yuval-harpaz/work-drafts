function [xyz,vrti]=neigbourVerts(fv,verti)
% requires fv.faces and fv.vertices
% verti=72, which vertex you want the neighbours of
    facei=find(fv.faces==verti);
    facei(facei>18000)=facei(facei>18000)-18000; % for 2nd column
    facei(facei>18000)=facei(facei>18000)-18000; % for 3nd column
    vrt=fv.faces(facei,:)
    vrt=unique(vrt);
    vrti=vrt(vrt~=verti);
    xyz=fv.vertices(vrti,:)
end
    
    
    
