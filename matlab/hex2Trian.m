function hex2Trian(fv)
% requires fv.faces and fv.vertices
for verti=1
    facei=find(fv.faces==verti);
    facei(facei>18000)=facei(facei>18000)-18000; % for 2nd column
    facei(facei>18000)=facei(facei>18000)-18000; % for 3nd column
    plot3pnt(fv.vertices(verti,:),'bo')
    hold on;
    for fi=1:length(facei)
        for vi=1:3
            plot3pnt(fv.vertices(fv.faces(facei(fi),vi),:),'rx')
        end
    end
end
    
    
    
