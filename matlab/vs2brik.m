function vs2afni(cfg,vs)
% cfg should include func field with a name of functional data in BRIK
% format.
% cfg.TR (time of requisition) is the difference between two samples in S or ms.
% cfg.boxSize is [xmin xmax ymin ymax zmin zmax] in PRI order
% cfg.step is the spatial resolution in cm (0.5 ?)
% cfg.prefix for prefix
% vs has rows for voxels and columns for samples.
[err, Vfunc, Infofunc, ErrMessage] = BrikLoad (cfg.func);

!~/abin/coordstoijk.csh /home/yuval/Dropbox/poster2012/KurMask001+orig -120 -90 -20
-120 120   -90 90   -20 150
   7 43     40 6      49 1
slice=1;
found=false;
while found==false
    if isempty(find(Vfunc(slice,:,:)))
        slice=slice+1;
    else
        xmin=slice;
        found=true;
    end
end


InfoNewTSOut = Infofunc;
InfoNewTSOut.RootName = '';
InfoNewTSOut.BRICK_STATS = []; %automatically set
InfoNewTSOut.BRICK_FLOAT_FACS = []; %automatically set
InfoNewTSOut.IDCODE_STRING = '';%automatically set
OptTSOut.Scale = 1;
OptTSOut.Prefix = cfg.prefix;
OptTSOut.verbose = 1;
%write it
% dim APL
[err, ErrMessage, InfoNewTSOut] = WriteBrik (vs, InfoNewTSOut, OptTSOut);
