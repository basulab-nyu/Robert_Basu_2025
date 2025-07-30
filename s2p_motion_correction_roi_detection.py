import os
import sys
import numpy as np
import suite2p
import time
folder_path = '/gpfs/scratch/roberv04/Stripe_373'
folder_list = []
for i in os.listdir(os.path.abspath(folder_path)):
	sub_folder_path = os.path.join(folder_path,i)
	if os.path.isdir(sub_folder_path):
		if '_t' in sub_folder_path:
			folder_list.append(str(sub_folder_path))
		else:
			for j in os.listdir(sub_folder_path):
				sub2_folder_path = os.path.join(sub_folder_path,j)
				if '_t' in sub2_folder_path:
					folder_list.append(str(sub2_folder_path))
folder_list.sort()
print(*folder_list,sep="\n")
tiff_list = []
for i in range(len(folder_list)): tiff_list.append([])
for i,j in enumerate(folder_list):
	file_list = [str(os.path.join(folder_list[i],x)) for x in os.listdir(folder_list[i])]
	file_list.sort()
	for k in file_list:
		if k.endswith(".tif"):
			if '_Ch2_' in k:
				tiff_list[i].append(k)
check_list = []
for i,j in enumerate(tiff_list): check_list.append(len(tiff_list[i]))
zap_list = []
for i,j in enumerate(check_list):
	if j == 0:
		zap_list.append(i)
zap_list.reverse()
for i in zap_list:
	folder_list.pop(i)
	tiff_list.pop(i)
ms_tiff_list = []
for i,j in enumerate(tiff_list):
    tiff_list[i].sort()
    ms_tiff_list.extend(tiff_list[i])
ops = {
      'suite2p_version': '0.10.3',
      'look_one_level_down': 0,
      'fast_disk': [],
      'delete_bin': True,
      'mesoscan': False,
      'bruker': False,
      'bruker_bidirectional': False,
      'h5py': [],
      'h5py_key': 'data',
      'nwb_file': '',
      'nwb_driver': '',
      'nwb_series': '',
      'save_path0': [],
      'save_folder': [],
      'subfolders': [],
      'move_bin': False,
      'nplanes': 1,
      'nchannels': 1,
      'functional_chan': 1,
      'tau': 0.7,
      'fs': 30.0,
      'force_sktiff': False,
      'frames_include': -1,
      'multiplane_parallel': 0.0,
      'ignore_flyback': [],
      'preclassify': 0.0,
      'save_mat': True,
      'save_NWB': 0.0,
      'combined': 1.0,
      'aspect': 1.0,
      'do_bidiphase': False,
      'bidiphase': 0.0,
      'bidi_corrected': False,
      'do_registration': 1,
      'two_step_registration': 0.0,
      'keep_movie_raw': False,
      'nimg_init': 300,
      'batch_size': 1000,
      'maxregshift': 0.1,
      'align_by_chan': 1,
      'reg_tif': True,
      'reg_tif_chan2': True,
      'subpixel': 10,
      'smooth_sigma_time': 0.0,
      'smooth_sigma': 1.15,
      'th_badframes': 1.0,
      'norm_frames': True,
      'force_refImg': False,
      'pad_fft': False,
      'nonrigid': True,
      'block_size': [128, 128],
      'snr_thresh': 1.2,
      'maxregshiftNR': 5.0,
      '1Preg': False,
      'spatial_hp': 42,
      'spatial_hp_reg': 42.0,
      'spatial_hp_detect': 25,
      'pre_smooth': 2.0,
      'spatial_taper': 50.0,
      'roidetect': True,
      'spikedetect': False,
      'anatomical_only': 0.0,
      'cellprob_threshold': 0.0,
      'flow_threshold': 1.5,
      'sparse_mode': True,
      'diameter': 0,
      'spatial_scale': 0,
      'connected': 0,
      'nbinned': 5000,
      'max_iterations': 20,
      'threshold_scaling': 1.0,
      'max_overlap': 0.75,
      'high_pass': 100.0,
      'denoise': 0.0,
      'soma_crop': 1.0,
      'neuropil_extract': True,
      'inner_neuropil_radius': 2,
      'min_neuropil_pixels': 350,
      'lam_percentile': 50.0,
      'allow_overlap': False,
      'use_builtin_classifier': True,
      'classifier_path': 0,
      'chan2_thres': 0.65,
      'baseline': 'maximin',
      'win_baseline': 60.0,
      'sig_baseline': 10.0,
      'prctile_baseline': 8.0,
      'neucoeff': 0.7,
      'num_workers': 0,
      'num_workers_roi': -1,
      'do_phasecorr': True,
      'navg_frames_svd': 5000,
      'nsvd_for_roi': 1000,
      'smooth_masks': 1,
      'ratio_neuropil': 6.0,
      'ratio_neuropil_to_cell': 3,
      'tile_factor': 1.0,
      #'outer_neuropil_radius': inf,
      #'xrange': array([0, 0], dtype=int64),
      #'yrange': array([0, 0], dtype=int64),
      'outer_neuropil_radius': np.inf,
      'xrange': np.array([0, 0]),
      'yrange': np.array([0, 0]),
      'input_format': 'tif'
    }
db = {
      'h5py': [],
      'h5py_key': 'data',
      'look_one_level_down': False,
      'data_path': folder_path,      
      'subfolders': [],
      'fast_disk': folder_path,
      'tiff_list': ms_tiff_list,
      'save_folder': folder_path
    }
suite2p.run_s2p.run_s2p(ops,db)