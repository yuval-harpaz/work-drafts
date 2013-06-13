function M1=makeTrans(fromPnt,toPnt)
% uses spm function but here the from-to is in civilized order, as well as
% the XYZ: column 1 is X.
M1 = spm_eeg_inv_rigidreg(toPnt', fromPnt');