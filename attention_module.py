import torch
import torch.nn as nn
import torch.nn.functional as F

class ChannelAttention(nn.Module):
    def __init__(self, in_channels, heads, seq_len):
        super(ChannelAttention, self).__init__()
        self.attn = nn.MultiheadAttention(embed_dim=in_channels, num_heads=heads, batch_first=True)

    def forward(self, x):
        """
        x: [batch_size, seq_len, in_channels]
        """
        # 直接调用 MultiheadAttention，确保维度匹配
        attn_output, _ = self.attn(x, x, x)
        return attn_output
