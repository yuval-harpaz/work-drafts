function grad=tooManyGrads(source);
hdr=ft_read_header(source);
p=pdf4D('c,rfhp0.1Hz');
chi=channel_index(p,'ref');
refpos=channel_position(p,chi);
refname=channel_name(p,chi);
for ref276i=249:276
    reflabels{ref276i,1}='';
    for ref271i=1:23
        if hdr.grad.pnt(ref276i,1)==refpos(1,ref271i).position(1,1) &&...
                hdr.grad.pnt(ref276i,2)==refpos(1,ref271i).position(2,1) &&...
                hdr.grad.pnt(ref276i,3)==refpos(1,ref271i).position(3,1) &&...
                hdr.grad.ori(ref276i,1)==refpos(1,ref271i).direction(1,1) &&...
                hdr.grad.ori(ref276i,2)==refpos(1,ref271i).direction(2,1) &&...
                hdr.grad.ori(ref276i,3)==refpos(1,ref271i).direction(3,1)
            reflabels{ref276i,1}=refname{1,ref271i};
        end
    end
end
grad=hdr.grad;
badrefs=find(strcmp('',reflabels));
grad.tra = sparse(eye(size(grad.pnt,1)));


           