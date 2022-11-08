## Overview

This repository is the MATLAB codes related to the following article: "Hybrid HMM Decoder For Convolutional Codes By Joint Trellis-Like Structure and Channel Prior"

[**Pre-Print：** Hybrid HMM Decoder For Convolutional Codes By Joint Trellis-Like Structure and Channel Prior (arxiv.org)](https://arxiv.org/abs/2210.14749)

## Abstract of the Article

The anti-interference capability of wireless links is a physical layer problem for edge computing. Although convolutional codes have inherent error correction potential due to the redundancy introduced in the data, the performance of the convolutional code is drastically degraded due to multipath effects on the channel. In this paper, we propose the use of a Hidden Markov Model (HMM) for the reconstruction of convolutional codes and decoding by the Viterbi algorithm. Furthermore, to implement soft-decision decoding, the observation of HMM is replaced by Gaussian mixture models (GMM). Our method provides superior error correction potential than the standard method because the model parameters contain channel state information (CSI). We evaluated the performance of the method compared to standard Viterbi decoding by numerical simulation. In the multipath channel, the hybrid HMM decoder can achieve a performance gain of 4.7 dB and 2 dB when using hard-decision and soft-decision decoding, respectively. The HMM decoder also achieves significant performance gains for the RSC code, suggesting that the method could be extended to turbo codes.

## About this code

Source code for HMM-Decoder.

- Modulation: BPSK
- Eb/N0: 0-15 dB
- Block length: 1000 bits
- test_block: 1000
- K: 3
- P: 3
- Method: CONV or RSC
- Channel: AWGN or Multipath

#### Software platform

Matlab 2021a

#### Requirement

The code uses repository from Qiuqiang Kong:

- [matlab-hmm](https://github.com/qiuqiangkong/matlab-hmm)

#### Contents of directories

```
.
├── dev # latest working source code
├── test_v1 # archived for old version https://arxiv.org/abs/1810.07181v3
├── README.md 
└── LICENSE
```

#### Usage

1. Download this repository
2. Download [matlab-hmm](https://github.com/qiuqiangkong/matlab-hmm) and add it to `./src/matlab-hmm`.
3. Run `Config.m` to setup the SIMULATION PARAMETERS.
4. Run `HMM_Decoder.m` in MATLAB.

#### Results

If you want to get the figure in the paper, you would setup as follows:

Figure 4(a): The BER of the standard Viterbi Decoder, HMM decoder and RNN decoder [16] using hard-decision and soft-decision respectively in AWGN

channel.

```matlab
% Config.m
config.K = 3;      % K: constraint length
config.P = 3;      % P: the number of generator polynomial functions
config.method = 'CONV';         % CONV or RSC
config.train_packnum = 10;
config.test_packnum = 1000;
config.filename = './../dataset/AWGN.mat';
```

<img src="img/ber_awgn.png" alt="ber_awgn" style="zoom: 6%;" />



Figure 4(b):  The BER of the standard Viterbi Decoder, HMM decoder and RNN decoder [16] using hard-decision and soft-decision respectively in multiple channel.

```matlab
% Config.m
config.K = 3;      % K: constraint length
config.P = 3;      % P: the number of generator polynomial functions
config.method = 'CONV';         % CONV or RSC
config.train_packnum = 10;
config.test_packnum = 1000;
config.filename = './../dataset/Multipath.mat';
```

<img src="img/ber_multipath.png" alt="ber_multipath" style="zoom:6%;" />

Figure 8:  The validity of the hybrid HMM decoder on the RSC code.

```
% Config.m
config.K = 3;      % K: constraint length
config.P = 3;      % P: the number of generator polynomial functions
config.method = 'CONV';         % CONV or RSC
config.train_packnum = 10;
config.test_packnum = 1000;
config.filename = './../dataset/RSC.mat';
```

<img src="img/ber_RSC.png" alt="ber_RSC" style="zoom:6%;" />



## Citing

If you use this repository in your research, please cite this paper.

```
@article{li2022hybrid,
  title={Hybrid HMM Decoder For Convolutional Codes By Joint Trellis-Like Structure and Channel Prior},
  author={Li, Haoyu and Wang, Xuan and Liu, Tong and Fang, Dingyi and Liu, Baoying},
  journal={arXiv preprint arXiv:2210.14749},
  year={2022}
}
```

If you are for commercial use, please contact the author.

AUTHOR: Haoyu Li
CONTACT: lihaoyu@stumail.nwu.edu.cn

## Acknowledgment

