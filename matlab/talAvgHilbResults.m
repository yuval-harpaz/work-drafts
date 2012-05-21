load /home/yuval/Desktop/tal/subs36
AEC1V1=zeros(18,18);AEC2V1=zeros(18,18);
CAE1V1=zeros(18,18);CAE2V1=zeros(18,18);
AEC1V2=zeros(18,18);AEC2V2=zeros(18,18);
CAE1V2=zeros(18,18);CAE2V2=zeros(18,18);
corrWts1V1=zeros(18,18);corrWts1V2=zeros(18,18);corrWts2V1=zeros(18,18);corrWts2V2=zeros(18,18);
for i=1:29
    load(['/home/yuval/Desktop/talResults/Hilbert/',subsV1{i},'_h2_alpha.mat'])
    AEC1V1=AEC1V1+AEC1;AEC2V1=AEC2V1+AEC2;
    CAE1V1=CAE1V1+CAE1;CAE2V1=CAE2V1+CAE2;
    corrWts1V1=corrWts1V1+abs(corrWts1);corrWts2V1=corrWts2V1+abs(corrWts2);
    load(['/home/yuval/Desktop/talResults/Hilbert/',subsV2{i},'_h2_alpha.mat'])
    AEC1V2=AEC1V2+AEC1;AEC2V2=AEC2V2+AEC2;
    CAE1V2=CAE1V2+CAE1;CAE2V2=CAE2V2+CAE2;
    corrWts1V2=corrWts1V2+abs(corrWts1);corrWts2V2=corrWts2V2+abs(corrWts2);
end
AEC1V1=AEC1V1./29;AEC2V1=AEC2V1./29;
CAE1V1=CAE1V1./29;CAE2V1=CAE2V1./29;
AEC1V2=AEC1V2./29;AEC2V2=AEC2V2./29;
CAE1V2=CAE1V2./29;CAE2V2=CAE2V2./29;
corrWts1V1=corrWts1V1./29;corrWts1V2=corrWts1V2./29;corrWts2V1=corrWts2V1./29;corrWts2V2=corrWts2V2./29;