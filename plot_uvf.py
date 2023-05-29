#Script to plot VLBI-clean-images and to save image-parameters to a table (csv and latex table)

#The interferometric FITS-files of one source taken at different observation dates should be stored in one common folder and named with their individual observation date (e.g. 0537-286_2020-08-30_remap.fits).


#######################################
#############USER-INTERFACE############
#######################################

#Input path of the common folder where the interferometric FITS-files are stored
input_path = './'

#Output path of the folder where the resulting images are stored
output_path = './source_images/'

#Source name 
name = '' #if name == '', the source name from difmap will be used

#noise 
fit_noise = True #if True, the noise value and rms deviation will be fitted as described in the PhD-thesis of Moritz Böck (https://www.physik.uni-wuerzburg.de/fileadmin/11030400/Dissertation_Boeck.pdf); if False, the noise frome difmap will be used

#Unit-selection 
unit = 'mas' #possible units: 'mas', 'arcsec', 'arcmin' and 'deg'. Default (any other string) value is 'deg'. 

#Map limits
ra_min = -50
ra_max = 50
dec_min = -50
dec_max = 50

#Contour plot
contour = True #if True, a contour plot will be done
contour_color = 'black' #input: array of color-strings; if None, the contour-colormap (contour_cmap) will be used
contour_cmap = None #matplotlib colormap string
contour_alpha = 1 #transparency
contour_width = 0.5 #contour linewidth
sigma_contour_limit=5 #show sigma lines starting from X-sigma

#Image colormap
im_colormap = True #if True, a image colormap will be done
im_color = 'inferno' #string for matplotlib colormap
sigma_color_limit = 5 #show color above X-sigma

#Fontsize
fontsize = 0 #if fontsize <= 0, the standard is used

#Plot mode
individual_plots = True #if True, all epochs will be plotted to individual pdf files
combined_plot = False #if True, all epochs will be fitted to one combined pdf file

#Write table
csv_table = False #if True, image parameter will be written to a csv table
latex_table = False #if True, image parameter will be written to a latex table


#######################################
############PROGRAM-CORE###############
#######################################


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse
from matplotlib.backends.backend_pdf import PdfPages
import matplotlib.colors as colors
from astropy.io import fits
from astropy.modeling import models, fitting
import os
from mpl_toolkits.axes_grid1 import make_axes_locatable
import glob
import sys

plt.rcParams['savefig.dpi'] = 600

#Load fits files
files = [sys.argv[1]]
outname = sys.argv[2]

files = np.sort(files)

#Set default value for unit
if (unit != 'mas') and (unit != 'arcsec') and (unit != 'arcmin'):
    unit = 'deg'

#Unit selection and adjustment
if unit == 'arcmin':
    scale = 60.
    
elif unit == 'arcsec':
    scale = 60.*60.
    
elif unit == 'mas':
    scale = 60.*60.*1000.

else:
    scale = 1.
    
#Set image parameter for tables
if (latex_table == True) or (csv_table == True):
    date_tab = np.array(['YYYY-MM-DD', '(1)'])
    array_tab = np.array(['', '(2)'])
    total_flux_tab = np.array(['[Jy]', '(3)'])
    peak_flux_tab = np.array(['[Jy/beam]', '(4)'])
    rms_noise_tab = np.array(['[mJy/beam]', '(5)'])
    beam_maj_tab = np.array(['['+unit+']', '(6)'])
    beam_min_tab = np.array(['['+unit+']', '(7)'])
    beam_pa_tab = np.array(['[deg]', '(8)'])

#Plot combined pdf
if combined_plot == True:
    hdu_list = fits.open(files[0])
    if name == '':
        objectname = hdu_list[0].header["OBJECT"]
        name = objectname
    if im_colormap == True:
        #pp = PdfPages(output_path + name + '_colormap_images.pdf')
        pass
    else:
        pp = PdfPages(output_path + name + '_contour_images.pdf')
    hdu_list.close()

#Compute beam-position and color-range
flux_minima = np.array([])
flux_maxima = np.array([])
linthresh_values = np.array([])
beam_major_axes = np.array([])

for i in range(len(files)):
    hdu_list = fits.open(files[i])
    beam_major_axes = np.append(beam_major_axes, hdu_list[0].header["BMAJ"] * scale)

    if im_colormap == True:
        image_data = hdu_list[0].data
        Z = image_data[0, 0, :, :]
        flux_minima = np.append(flux_minima, np.min(Z))
        flux_maxima = np.append(flux_maxima, np.max(Z))
        linthresh_values = np.append(linthresh_values, sigma_color_limit * hdu_list[0].header["NOISE"])

    hdu_list.close()

#Fontsize
if fontsize > 0:
    plt.rc('axes', titlesize=fontsize)     # fontsize of the axes title
    plt.rc('axes', labelsize=fontsize)    # fontsize of the x and y labels
    plt.rc('xtick', labelsize=fontsize)    # fontsize of the tick labels
    plt.rc('ytick', labelsize=fontsize)

#Plot individual images
for i in range(len(files)):

    #Read clean files in
    hdu_list = fits.open(files[i])

    #Set name
    if name == '':
        objectname = hdu_list[0].header["OBJECT"]
        name = objectname
    
    #Convert Pixel into unit
    X = np.linspace(0, hdu_list[0].header["NAXIS1"], hdu_list[0].header["NAXIS1"], endpoint = False) #NAXIS1: number of pixels at R.A.-axis
    for j in range(len(X)):
        X[j] = (X[j] - hdu_list[0].header["CRPIX1"]) * hdu_list[0].header["CDELT1"] * scale #CRPIX1: reference pixel, CDELT1: deg/pixel
    X[int(hdu_list[0].header["CRPIX1"])] = 0.0
    
    Y = np.linspace(0, hdu_list[0].header["NAXIS2"], hdu_list[0].header["NAXIS2"], endpoint = False) #NAXIS2: number of pixels at Dec.-axis
    for j in range(len(Y)):
        Y[j] = (Y[j] - hdu_list[0].header["CRPIX2"]) * hdu_list[0].header["CDELT2"] * scale #CRPIX2: reference pixel, CDELT2: deg/pixel
    Y[int(hdu_list[0].header["CRPIX2"])] = 0.0

    extent = np.max(X), np.min(X), np.min(Y), np.max(Y)
    
    #Get image data
    image_data = hdu_list[0].data
    Z = image_data[0, 0, :, :]
    
    #Fit noise level (according to https://www.physik.uni-wuerzburg.de/fileadmin/11030400/Dissertation_Boeck.pdf)
    if fit_noise == True:
        Z1 = Z.flatten()
        bin_heights, bin_borders = np.histogram(Z1 - np.min(Z1) + 10 ** (-5), bins = "auto")
        bin_widths = np.diff(bin_borders)
        bin_centers = bin_borders[:-1] + bin_widths / 2.
        bin_heights_err = np.where(bin_heights != 0, np.sqrt(bin_heights), 1)
    
        t_init = models.Gaussian1D(np.max(bin_heights), np.median(Z1 - np.min(Z1) + 10 ** (-5)), 0.001)
        fit_t = fitting.LevMarLSQFitter()
        t = fit_t(t_init, bin_centers, bin_heights, weights = 1. / bin_heights_err)
    
        #Set contourlevels to mean value + 3 * rms_noise * 2 ** x
        levs1 = t.mean.value + np.min(Z1) - 10 ** (-5) + sigma_contour_limit * t.stddev.value * np.logspace(0, 100, 100, endpoint = False, base = 2)
        levs = t.mean.value + np.min(Z1) - 10 ** (-5) - sigma_contour_limit * t.stddev.value * np.logspace(0, 100, 100, endpoint = False, base = 2)
        levs = np.flip(levs)
        levs = np.concatenate((levs, levs1))

    else: 
        levs1 = 3 * hdu_list[0].header["NOISE"] * np.logspace(0, 100, 100, endpoint = False, base = 2)
        levs = np.flip(-levs1)
        levs = np.concatenate((levs, levs1))
    

    #PLOTTING
    fig, ax = plt.subplots()

    #Plot look tuning
    axe_ratio = 'scaled'
    plt.axis(axe_ratio)
    plt.xlim(ra_min,ra_max)
    plt.ylim(dec_min,dec_max)
    plt.gca().invert_xaxis()
    plt.xlabel('Relative R.A. ['+unit+']')
    plt.ylabel('Relative DEC. ['+unit+']')



    #Image colormap
    if im_colormap == True:
        col = ax.imshow(Z, cmap = im_color, norm = colors.SymLogNorm(linthresh = np.max(linthresh_values), linscale = 0.5, vmin = 1 * np.max(linthresh_values), vmax = 0.5 * np.max(flux_maxima), base = 10.), extent = extent, origin = 'lower')
        divider = make_axes_locatable(ax)
        cax = divider.append_axes("right", size = "5%", pad = 0.05)
        cbar = fig.colorbar(col, use_gridspec = True, cax = cax)
        cbar.set_label('Flux Density [Jy/beam]')
        


    #Contour plot
    if contour == True:
        if im_colormap == True:
            ax.contour(X, Y, Z, linewidths = contour_width, levels = levs, colors = 'white', alpha = contour_alpha, cmap = contour_cmap)
        else:
            ax.contour(X, Y, Z, linewidths = contour_width, levels = levs, colors = contour_color, alpha = contour_alpha, cmap = contour_cmap)


    #Set beam parameters
    beam_maj = hdu_list[0].header["BMAJ"] * scale
    beam_min = hdu_list[0].header["BMIN"] * scale
    beam_pa = hdu_list[0].header["BPA"]

    #Peak flux density in Jy/beam
    peak_flux = np.max(Z)

    #Noise in mJy/beam
    if fit_noise == True:
        noise = t.stddev.value * 1000.
    else:
        noise = hdu_list[0].header["NOISE"] * 1000.

    #Set beam ellipse, sourcename and observation date positions
    size_x = np.absolute(ra_max) + np.absolute(ra_min)
    size_y = np.absolute(dec_max) + np.absolute(dec_min)
    if size_x > size_y:
        ell_x = ra_max - np.max(beam_major_axes) 
        ell_y = dec_min + np.max(beam_major_axes)
        name_x = ra_max - size_x * 0.05
        name_y = dec_max - size_x * 0.05
        date_x = ra_min + size_x * 0.05
        date_y = name_y
        sigma_x = date_x
        sigma_y = dec_min + size_x * 0.05 
        peak_x = sigma_x
        peak_y = sigma_y + np.absolute(dec_max) * 0.1 
    else:
        ell_x = ra_max - np.max(beam_major_axes) 
        ell_y = dec_min + np.max(beam_major_axes) 
        name_x = ra_max - size_y * 0.05
        name_y = dec_max - size_y * 0.05
        date_x = ra_min + size_y * 0.05
        date_y = name_y
        sigma_x = date_x
        sigma_y = dec_min + size_y * 0.05 
        peak_x = sigma_x
        peak_y = sigma_y + np.absolute(dec_max) * 0.1 

    #Plot beam
    beam = Ellipse([ell_x, ell_y], beam_maj, beam_min, -beam_pa + 90, fc = 'grey')
    ax.add_artist(beam)

    #Plot date
    time = hdu_list[0].header["DATE-OBS"]
    time = time.split("/")
    if len(time)==1:
        date = time[0]
    elif len(time)==3:
        if len(time[0])<2:
            day = "0" + time[0]
        else:
            day = time[0]
        if len(time[1])<2:
            month = "0" + time[1]
        else:
            month = time[1]
        if len(time[2])==2:
            if 45 < int(time[2]) < 100:
                year = "19" + time[2]
            elif int(time[2]) < 46:
                year = "20" + time[2]
        elif len(time[2])==4:
            year = time[2]
        date = year + "-" + month + "-" + day	
    if im_colormap == True:
        ax.text(date_x, date_y, date, color = 'white', ha = 'right', va = 'top')
    else:
        ax.text(date_x, date_y, date, color = 'black', ha = 'right', va = 'top')

    #Plot name
    if im_colormap == True:
        ax.text(name_x, name_y, name, color = 'white', ha = 'left', va = 'top')
    else:
        ax.text(name_x, name_y, name, color = 'black', ha = 'left', va = 'top')

    #Plot sigma
    if im_colormap == True:
        ax.text(sigma_x, sigma_y, r"$\sigma =$" + str(np.around(noise, decimals = 2)) + r" $\mathrm{mJy/beam}$", color = 'white', ha = 'right', va = 'bottom')
    else:
        ax.text(sigma_x, sigma_y, r"$\sigma =$" + str(np.around(noise, decimals = 2)) + r" $\mathrm{mJy/beam}$", color = 'black', ha = 'right', va = 'bottom')

    #Plot peak flux
    if im_colormap == True:
        ax.text(peak_x, peak_y, r"$S_{\mathrm{peak}} =$" + str(np.around(peak_flux, decimals = 2)) + r" $\mathrm{Jy/beam}$", color = 'white', ha = 'right', va = 'bottom')
    else:
        ax.text(peak_x, peak_y, r"$S_{\mathrm{peak}} =$" + str(np.around(peak_flux, decimals = 2)) + r" $\mathrm{Jy/beam}$", color = 'black', ha = 'right', va = 'bottom')

    #Tight layout
    plt.tight_layout()

    #Save images
    if combined_plot == True:
        pp.savefig(fig)
    if individual_plots == True:
        if im_colormap == True: 
            #plt.savefig(output_path + name + '_' + date + '_colormap_image.pdf')
            plt.savefig(outname)	
        else:
            #plt.savefig(output_path + name + '_' + date + '_contour_image.pdf')
            plt.savefig(outname)

    #Parameters for tables
    if (csv_table == True) or (latex_table == True):

        #Total flux density in Jy
        comp_data = hdu_list[1].data
        comp_data1 = np.zeros((len(comp_data), len(comp_data[0])))
        for j in range(len(comp_data)):
            comp_data1[j, :] = comp_data[j]
        total_flux = np.sum(comp_data1[:,0])

        #Peak flux density in Jy/beam
        peak_flux = np.max(Z)

        #Noise in mJy/beam
        if fit_noise == True:
            noise = t.stddev.value * 1000.
        else:
            noise = hdu_list[0].header["NOISE"] * 1000.

        date_tab = np.append(date_tab, date)
        array_tab = np.append(array_tab, '')
        total_flux_tab = np.append(total_flux_tab, np.around(total_flux, decimals = 2))
        peak_flux_tab = np.append(peak_flux_tab, np.around(peak_flux, decimals = 2))
        rms_noise_tab = np.append(rms_noise_tab, np.around(noise, decimals = 2))
        beam_maj_tab = np.append(beam_maj_tab, np.around(beam_maj, decimals = 3))
        beam_min_tab = np.append(beam_min_tab, np.around(beam_min, decimals = 3))
        beam_pa_tab = np.append(beam_pa_tab, np.around(beam_pa, decimals = 3))

    hdu_list.close()

if combined_plot == True:
    pp.close()

#Write tables
if (csv_table == True) or (latex_table == True):
    table_df = pd.DataFrame()
    table_df["Date"] = date_tab
    table_df["Array"] = array_tab
    table_df[r"$S_\mathrm{tot}$"] = total_flux_tab 
    table_df[r"$S_\mathrm{peak}$"] = peak_flux_tab 
    table_df[r"$\sigma_\mathrm{rms}$"] = rms_noise_tab 
    table_df[r"$b_\mathrm{maj}$"] = beam_maj_tab 
    table_df[r"$b_\mathrm{min}$"] = beam_min_tab 
    table_df["P.A."] = beam_pa_tab 

if csv_table == True:
    table_df.to_csv(output_path + name + '_image_parameter.csv', index = False, index_label = False)

if latex_table == True:
    table_df.to_latex(output_path + name + '_image_parameter.tex', index = False, index_names = False, label = 'imageparam')


