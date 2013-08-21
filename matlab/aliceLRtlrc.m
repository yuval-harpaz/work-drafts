
function aliceLRtlrc(prefix,avg)
%sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
cd /home/yuval/Copy/MEGdata/alice/func

for subi=1:8
    [err, V, Info, ErrMessage] = BrikLoad ([prefix,'_',num2str(subi),'+tlrc']);
    Vlr=flipdim(V,1);
    Vdif=V-Vlr;
    Vdif(1:16,:,:)=0;
    InfoNewTSOut = Info;
    InfoNewTSOut.RootName = '';
    InfoNewTSOut.BRICK_STATS = [];
    InfoNewTSOut.BRICK_FLOAT_FACS = [];
    InfoNewTSOut.IDCODE_STRING = '';
    InfoNewTSOut.BRICK_TYPES=3*ones(1,1); % 1 short, 3 float.
    InfoNewTSOut.DATASET_RANK(2)=1;
    OptTSOut.Scale = 1;
    OptTSOut.Prefix = [prefix,'LRdif_',num2str(subi)];
    OptTSOut.verbose = 1;
    OptTSOut.View = '+tlrc'
    Vsymm=double(Vlr+V>0);
    WriteBrik (Vdif, InfoNewTSOut, OptTSOut);
end
if avg
    aliceAvgTlrc([prefix,'LRdif'],1)
end