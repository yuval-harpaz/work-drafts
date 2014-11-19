function distances=chanDist;
hdr=ft_read_header(source);
[~,iL]=ismember('A69',hdr.grad.label);
[~,iR]=ismember('A81',hdr.grad.label);
distLim=floor(sqrt(sum((hdr.grad.chanpos(iL,1:3)-hdr.grad.chanpos(iR,1:3)).^2))*100);
distances(i,j)=zeros(248);
for i=1:248
    for j=1:248
        [~,I]=ismember(['A',num2str(i)],hdr.grad.label);
        [~,J]=ismember(['A',num2str(j)],hdr.grad.label);
        distances(i,j)=sqrt(sum((hdr.grad.chanpos(I,1:3)-hdr.grad.chanpos(J,1:3)).^2))*100;
    end
end
