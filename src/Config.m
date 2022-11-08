clc;clear all;close all;
%%
global config
config.K = 3;      % K: constraint length
config.P = 3;      % P: the number of generator polynomial functions
config.method = 'CONV';         % CONV or RSC
config.train_packnum = 10;
config.test_packnum = 1000;
config.filename = './../dataset/AWGN.mat';
