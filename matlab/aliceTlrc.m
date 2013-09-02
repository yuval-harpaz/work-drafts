
function aliceTlrc(prefix)
%sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
cd /home/yuval/Copy/MEGdata/alice
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};

!echo > ~/alice2tlrc 
for subi=1:8
    cd([sf{subi},'/MRI'])
    eval(['!echo "cd ',pwd,'" >> ~/alice2tlrc'])
    eval(['!echo "@auto_tlrc -apar ortho+tlrc -input ',prefix,'+orig -dxyz 5" >> ~/alice2tlrc'])
    eval(['!echo "mv ',prefix,'+tlrc.HEAD /home/yuval/Copy/MEGdata/alice/func/',prefix,'_',num2str(subi),'+tlrc.HEAD" >> ~/alice2tlrc']);
    eval(['!echo "mv ',prefix,'+tlrc.BRIK /home/yuval/Copy/MEGdata/alice/func/',prefix,'_',num2str(subi),'+tlrc.BRIK" >> ~/alice2tlrc']);
    cd ../..
end
disp('run ./alice2tlrc')