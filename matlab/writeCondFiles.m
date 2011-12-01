function writeCondFiles(cond,source);
eval(['!echo ',cond,' ',source,' >> conditions'])
end