# matlab_lint

These files are intented to help lint matlab funcitons and scripts. They can be used with special-measure
###get information on a single file

```
%% here is an example used on a single file:
file_info = matlab_lint('some_file.m');
out = 

           is_func: 1
          problems: {'improper doc string'}
        code_lines: 12
     comment_lines: 2
          new_text: 'function [out fileDir] = get_files(ffilter)
% function [out f...'
    builtin_linter: [2x1 struct]
````
###crawl a directory

```
%% here is an example crawling a directory

ff = rDir(pwd); % get directory info
[~,ext] = strtok({ff.name},'.'); % these are file extensions
ff = ff(strcmp(ext,'.m')); %only want the m-files
for j = 1:length(ff)
   tmp = matlab_lint(ff(j).name);
   if ~isempty(fieldnames(tmp))
        ff(j).passed = isempty(tmp.problems);
        ff(j).problems = tmp.problems;
   else % returns empty if can't open file
      ff(j).passed = 0;
      fprintf('empty\n')
   end
end

bad_files = ff(~[ff.passed]);
bad_files = 
        name: 'dynamic_gui.m'
        date: '28-Mar-2014 13:18:51'
       bytes: 3193
       isdir: 0
     datenum: 7.3569e+05
      passed: 0
    problems: {'improper doc string'}
```

