% PSG绘图，观测信号并验证数据是否正确。
% by Jim 2018.10.11
function visualization(data_pkg)
    sample_rate = data_pkg.sample_rate;%采样率
    seg_time = 30;%分段长度30s
    file_id = data_pkg.file_id;%文件ID
    
    expert_stages = load('slp48stages.txt');  % 专家分期

    %多通道信号
    ecg = data_pkg.ecg;
    resp_chest = data_pkg.resp_chest;
    eog = data_pkg.eog;
    chin_emg = data_pkg.chin_emg;
    EEG_C4A1 = data_pkg.EEG_C4A1;
    %多通道信号
    
    signal_len = length(chin_emg);%信号总长
    total_seg = floor(signal_len / sample_rate / seg_time);%分段总数(丢掉最后不完整的段)
    
    x = (1 : seg_time*sample_rate)/sample_rate;%横轴坐标点
    interval_x = (1 : 0.5*sample_rate : seg_time*sample_rate)/sample_rate;%横轴做0.5s的间隔
    interval_y = (-100 : 100 : 500);
    vertical_line = meshgrid(interval_x, interval_y);
    horizental_line = meshgrid(interval_y, interval_x);
    
    for epoch = 1 : total_seg
        %30s分段信号
        ecg_epoch = ecg((epoch-1)*seg_time*sample_rate+1 : epoch*seg_time*sample_rate);
        resp_chest_epoch = resp_chest((epoch-1)*seg_time*sample_rate+1 : epoch*seg_time*sample_rate);
        eog_epoch = eog((epoch-1)*seg_time*sample_rate+1 : epoch*seg_time*sample_rate);
        chin_emg_epoch = chin_emg((epoch-1)*seg_time*sample_rate+1 : epoch*seg_time*sample_rate);
        EEG_C4A1_epoch = EEG_C4A1((epoch-1)*seg_time*sample_rate+1 : epoch*seg_time*sample_rate);
        %30s分段信号
        
        %可视化设置（原始数据测量幅值太小）
%         EEG_C4A1_epoch = EEG_C4A1_epoch ./ 1;
%         chin_emg_epoch = chin_emg_epoch ./ 2;
%         eog_epoch = eog_epoch .* 2;
        resp_chest_epoch = resp_chest_epoch .* 50;
        ecg_epoch = ecg_epoch .* 20;
        %可视化设置
        
        %可视化偏移量
        EEG_C4A1_epoch = EEG_C4A1_epoch + 0*100;
        chin_emg_epoch = chin_emg_epoch + 1*100;
        eog_epoch = eog_epoch + 2*100;
        resp_chest_epoch = resp_chest_epoch + 4*100;
        ecg_epoch = ecg_epoch + 3*100;
        %可视化偏移量
        
        plot(interval_x, horizental_line, '--');
        hold on
        plot(vertical_line, interval_y, '--');
        hold on
        plot(x, EEG_C4A1_epoch, 'k');
        hold on
        plot(x, chin_emg_epoch, 'k');
        hold on
        plot(x, eog_epoch, 'b');
        hold on
        plot(x, resp_chest_epoch, 'm');
        hold on
        plot(x, ecg_epoch, 'm');
        hold off
        xlabel('时间 秒/s')
        set(gca, 'ytick', (-50 : 50 :450))
        set(gca, 'yticklabel', {'-------', 'EEG\_C4A1-100μV', '-------', 'EMG\_Chin-100μV', '-------', ...
            'EOG-100μV', '-------', 'ECG-1mV', '-------', 'RESP\_CHEST-1mV', '-------'});
        expert_stage_str = '';
        switch expert_stages(epoch)
            case 0
                expert_stage_str = 'WAKE';
            case 1
                expert_stage_str = 'REM';
            case 2
                expert_stage_str = 'N1';
            case 3
                expert_stage_str = 'N2';
            case 4
                expert_stage_str = 'N3';
        end
        title(['被试--slp', num2str(file_id), '--整晚睡眠约', num2str(roundn(signal_len/sample_rate/60/60, -1)), ...
               '小时，第', num2str((epoch-1)*30/60), '分钟到第', num2str(epoch*30/60), '分钟多导睡眠图-', expert_stage_str]);
        pause;
    end
end