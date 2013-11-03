
function aliceLRtlrcB(prefix,method,maskFac)
%
%sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
cd /home/yuval/Copy/MEGdata/alice/func/B
if ~exist ('maskFac','var')
    maskFac='';
end
if ~exist ('method','var')
    method='dif';
end
for subi=1:8
    [~, V, Info, ~] = BrikLoad ([prefix,'_',num2str(subi),'+tlrc']);
    Vlr=flipdim(V,1);
    switch method
        case 'dif'
            Vout=V-Vlr;
        case 'div'
            Vout=(V-Vlr)./V;
    end
    Vout(1:16,:,:)=0;
    if ~isempty(maskFac)
        Vsum=V+Vlr;
        maxVal=max(max(max(max(Vsum,[],4),[],3),[],2))/2;
        thr=maskFac*maxVal;
        Vout(V<thr)=0;
    end
    OptTSOut.Scale = 1;
    OptTSOut.Prefix = [prefix,'LR',method,'_',num2str(subi)];
    OptTSOut.verbose = 1;
    OptTSOut.View = '+tlrc';
    WriteBrik (Vout, Info, OptTSOut);
    %    masktlrc([OptTSOut.Prefix,'+tlrc'],'~/SAM_BIU/docs/MASKctx+tlrc')
end