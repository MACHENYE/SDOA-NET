#!/bin/bash

# filepath: /d:/_code/project/SDOA-Net-main/train_and_log.sh

# 定义日志文件
LOG_FILE="validation_loss.log"

# 初始化最低验证损失为一个足够大的值
MIN_VAL_LOSS=999999

# 训练和记录验证损失的函数
train_and_log() {
    # 运行训练脚本并将输出重定向到临时文件
    python train.py > temp_output.log 2>&1

    # 从输出中提取验证损失
    VAL_LOSS=$(grep "Validation Loss:" temp_output.log | tail -1 | awk '{print $NF}')

    # 检查是否是最低验证损失
    if (( $(echo "$VAL_LOSS < $MIN_VAL_LOSS" | bc -l) )); then
        MIN_VAL_LOSS=$VAL_LOSS
        echo "New minimum validation loss: $MIN_VAL_LOSS" >> $LOG_FILE
    fi

    # 记录当前验证损失
    echo "Current validation loss: $VAL_LOSS" >> $LOG_FILE
}

# 每半小时运行一次训练和记录
while true; do
    # 调用训练和记录函数
    train_and_log
    if (( $(echo "$MIN_VAL_LOSS < 40" | bc -l) )); then
        echo "Stopping training as minimum validation loss ($MIN_VAL_LOSS) is less than 40." >> $LOG_FILE
        break
    fi
done
