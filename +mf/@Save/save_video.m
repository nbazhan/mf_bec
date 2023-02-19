function save_video(obj)

if ~isfield(obj.drs, 'video')
    obj.drs.video = [obj.folder, 'video/'];
    if ~exist(obj.drs.video, 'dir')
        util.create_folder(obj.drs.video);
    end
end

% save information about model in text file
info = obj.get_video_info();
f = fopen([obj.drs.video 'INFO.txt'],'w');
fprintf(f, info);
fclose(f);

frame_rate = 7;

if isfield(obj.drs, 'ills')
    util.make_video(obj.drs.ills, [obj.drs.video, '_ills'], frame_rate)
end

if isfield(obj.drs, 'ills_fr')
    util.make_video(obj.drs.ills_fr, [obj.drs.video, '_ills_fr'], frame_rate)
end

if isfield(obj.drs, 'ills_jv')
    util.make_video(obj.drs.ills_jv, [obj.drs.video, '_ills_jv'], frame_rate)
end

if isfield(obj.drs, 'ills_ro')
    util.make_video(obj.drs.ills_ro, [obj.drs.video, '_ills_ro'], frame_rate)
end

if isfield(obj.drs, 'ills_ro_2')
    util.make_video(obj.drs.ills_ro_2, [obj.drs.video, '_ills'], frame_rate)
end

if isfield(obj.drs, 'ills_1d')
    util.make_video(obj.drs.ills_1d, [obj.drs.video, '_ills'], frame_rate)
end

