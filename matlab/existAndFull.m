function logic=existAndFull(varName,workSpace)
%checks if you have the variable and if it is not empty
if ~exist('workSpace','var')
    workSpace='caller';
end
xist=evalin(workSpace,['exist(''',varName,''',''','var''',');']);
if xist && evalin(workSpace,['~isempty(',varName,');']);
    logic=true;
else
    logic=false;
end
