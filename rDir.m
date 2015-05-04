function out = rDir(dname)
%function out = rDir(dname)
% recursively crawls directory and sub directories for file info
d = dir(dname);
current_dir = dname;
out = d(~[d.isdir]);
to_crawl = d([d.isdir]);
tmp = struct('name',{},'date',{},'bytes',{},'isdir',{},'datenum',{});
last_dir = current_dir;
for i=1:length(to_crawl)
    current_dir = [last_dir, filesep, to_crawl(i).name];
    if ~strcmp(to_crawl(i).name(1), '.')
        tmp2 = rDir_internal(current_dir);
        for j = 1:length(tmp2)
            tmp2(j).name =  [current_dir, filesep,  tmp2(j).name];
        end
        tmp = [tmp; tmp2]; %#ok<AGROW>
    end
end
out = [out;tmp];

end

% this function is used internally
% does the exact same thing but doesn't reappend the base directory
function out = rDir_internal(dname)
d = dir(dname);
current_dir = dname;
out = d(~[d.isdir]);
to_crawl = d([d.isdir]);
tmp = struct('name',{},'date',{},'bytes',{},'isdir',{},'datenum',{});
last_dir = current_dir;
for i=1:length(to_crawl)
    current_dir = [last_dir, filesep, to_crawl(i).name];
    if ~strcmp(to_crawl(i).name(1), '.')
        tmp2 = rDir_internal(current_dir);
        tmp = [tmp; tmp2];  %#ok<AGROW>
    end
end
out = [out;tmp];

end