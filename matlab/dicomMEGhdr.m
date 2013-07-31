function dicomMEGhdr
!ls>LS.txt
LS=importdata('LS.txt');
mkdir('dcm')
for linei=1:length(LS)
    if iscell(LS(linei,1))
        if ischar(LS{linei,1})
            if strcmp(LS{linei,1}(1,end-3:end),'.dcm')
                dcm=LS{linei,1};
                info = dicominfo(dcm);
                Y = dicomread(info);
                info.SeriesDescription='MEG_dipoles';
                info.ProtocolName='MEG_dipoles';
                % figure, imshow(Y);
                dicomwrite(Y, ['dcm/',dcm], info);
            end
        end
    end
end
!rm LS.txt