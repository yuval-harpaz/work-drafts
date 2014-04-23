sRate=1000;
data=rand(100,300*sRate);
data=data-0.5;
lf=correctLF(data,sRate,'time',1000,50,4);
sRate=1017.23;
data=rand(100,300*sRate);
data=data-0.5;
lf1017=correctLF(data,sRate,'time',1000,50,4);
