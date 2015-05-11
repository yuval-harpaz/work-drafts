function pnt_complex=findPerpendicular(pnt)

[O,r]=fitsphere(pnt);
A=[]; R=[]; C=[];
pnt_complex=zeros(size(pnt,1),size(pnt,2), 4);
pnt_complex(:,:,1)=pnt;
for p=1:size(pnt,1)
    
    P=pnt(p,:);
    v=P-O;
    Q=P;
    
    a=v(1);b=v(2);c=v(3);
    d=v(1)*Q(1)+v(2)*Q(2)+v(3)*Q(3);
    d=-d;
    R(p,1:3)=pnt(p,:)+((pnt(p,:)-O)/norm(pnt(p,:)-O, 2));
    if c==0
        RR=pnt(p,:)+((pnt(p,:)-O)/norm(pnt(p,:)-O, 2));
        p1=num2str(P(1));
        p2=num2str(P(2));
        r1=num2str(RR(1));
        r2=num2str(RR(2));
        syms x y;
        [x,y] = solve(['(x-',p1,')^2+(y-',p2,')^2=1'],['(x-',r1,')^2+(y-',r2,')^2=2']);
        A(p,1:3)=[x(1),y(1),P(3)];
        C(p,1:3)=pnt(p,:)+(cross((A(p,:)-P),(R(p,:)-P))./norm(cross((A(p,:)-P),(R(p,:)-P))));
    %% Plane
    elseif a==0
        RR=pnt(p,:)+((pnt(p,:)-O)/norm(pnt(p,:)-O, 2));
        p3=num2str(P(3));
        p2=num2str(P(2));
        r3=num2str(RR(3));
        r2=num2str(RR(2));
        syms z y;
        [z,y] = solve(['(z-',p3,')^2+(y-',p2,')^2=1'],['(z-',r3,')^2+(y-',r2,')^2=2']);
        A(p,1:3)=[P(1),z(1),y(1)];
        C(p,1:3)=pnt(p,:)+(cross((A(p,:)-P),(R(p,:)-P))./norm(cross((A(p,:)-P),(R(p,:)-P))));
    else
        plane=pnt(:,1:2);
        plane(:,3)=(-d-pnt(:,1).*a-pnt(:,2).*b)./c;
        D=d+b*P(2);
        z_lim=round(minmax(plane(:,3)'));
        z=z_lim(1);
        x=-(c*z+D)/a;
        y=P(2);
        y=repmat(y,size(z,2),1);
        
        %% selecting a specific point (e.g., 1)
        vec=[P(1)-x(1), P(2)-y(1), P(3)-z(1)];
        vec2=vec/norm(vec,2);
        vec3=P+vec2;
        %     if sum(isnan(vec3))
        %         error('nan')
        %     end
        A(p,1:3)=vec3;
        C(p,1:3)=pnt(p,:)+(cross((A(p,:)-P),(R(p,:)-P))./norm(cross((A(p,:)-P),(R(p,:)-P))));
    
        
    
        %         disp('')
        %         plane=pnt;
        %         plane(:,2)=(-d-pnt(:,1).*a-pnt(:,2).*b)./c;
        
        
    end
    
    
    
end
pnt_complex(:,:,2)=A; % one perpendicular dipole (A for anterior)
pnt_complex(:,:,3)=C; % second (crossed) perpendicular dipole
pnt_complex(:,:,4)=R; % radial dipole
vol.o=O;
vol.r=r;
figure;
ft_plot_vol(vol,'facealpha',0.9)
hold on
line([pnt(:,1)';A(:,1)'],[pnt(:,2)';A(:,2)'],[pnt(:,3)';A(:,3)'],'color',[0,0,0])
line([pnt(:,1)';C(:,1)'],[pnt(:,2)';C(:,2)'],[pnt(:,3)';C(:,3)'],'color',[1,0,0])
