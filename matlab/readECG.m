function ECG = readECG(inFile)

% read the ECG channel and adjust it so the R peak will be positive
% (assuming that the R peak is the highest in the data)

p = pdf4D(inFile);
hdr = ft_read_header(inFile);

chi = channel_index(p,'E34', 'name');
ECG = double(read_data_block(p,[],chi));
nFactor = max(ECG);
nECG = ECG/nFactor;
nECG = nECG - mean(nECG);
amp = max(nECG);
ampN = min(nECG);

if abs(ampN) > abs(amp)
    ECG = -ECG;
end

plot(ECG)


