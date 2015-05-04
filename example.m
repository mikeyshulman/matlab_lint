%% example

tic
ff = rDir(pwd); % get directory info
[~,ext] = strtok({ff.name},'.'); % these are file extensions
ff = ff(strcmp(ext,'.m')); %only want the m-files
for j = 1:length(ff)
   tmp = matlab_lint(ff(j).name);
   if ~isempty(fieldnames(tmp))
       % its good if function and good doc, or neither
        ff(j).passed = tmp.good_doc_string == tmp.is_func;
   else
      ff(j).passed = 0; 
   end
end

bad_files = ff(~[ff.passed]);
bad_files = {bad_files.name};
toc