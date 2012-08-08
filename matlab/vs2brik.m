[err, Vfunc, Infofunc, ErrMessage] = BrikLoad ('catPZ+orig');
InfoNewTSOut = Infofunc;
InfoNewTSOut.RootName = '';
InfoNewTSOut.BRICK_STATS = []; %automatically set
InfoNewTSOut.BRICK_FLOAT_FACS = []; %automatically set
InfoNewTSOut.IDCODE_STRING = '';%automatically set
OptTSOut.Scale = 1;
OptTSOut.Prefix = 'Demo1_TS';
OptTSOut.verbose = 1;
!rm Demo1_TS*
%write it
% dim APL
[err, ErrMessage, InfoNewTSOut] = WriteBrik (Vfunc, InfoNewTSOut, OptTSOut);
