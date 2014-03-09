function o=DenisHS
cd ~/Data/Denis/REST
load subs.mat subs
for subi=1:length(subs)
    sub=num2str(subs(subi));
    cd(sub)
%     fileName='clean-raw.fif';
    hs=ft_read_headshape('clean-raw.fif');
    hdr=ft_read_header('clean-raw.fif');
    grad = mne2grad(hdr);
    o(subi,1:3)=fitsphere(grad.coilpos(1:248,:));
    cd ..
end