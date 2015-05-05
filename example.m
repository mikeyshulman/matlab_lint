%% example

tic
ff = rDir(pwd); % get directory info
[~,ext] = strtok({ff.name},'.'); % these are file extensions
ff = ff(strcmp(ext,'.m')); %only want the m-files
for j = 1:length(ff)
   tmp = matlab_lint(ff(j).name);
   if ~isempty(fieldnames(tmp))
        ff(j).passed = isempty(tmp.problems);
   else % returns empty if can't open file
      ff(j).passed = 0; 
   end
end

bad_files = ff(~[ff.passed]);
bad_files = {bad_files.name};
toc