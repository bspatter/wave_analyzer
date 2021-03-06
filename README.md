### THIS README is under construction. Please be patient while it is completed. If you have questions, please contact the author at i.am.brandon.patterson@gmail.com and I will try to answer you directly or in the readme and then notify you. Thanks!

# Wave_analyzer

Tools and GUI for analyzing recorded ultrasound waves.

## Getting Started

To get the ultrasound wave analyzer running, take the following steps:
1. Download or git clone the 'wave_analyzer' repository to your local computer.
1. In MATLAB, navigate to the newly created 'wave_analyzer' directory.
1. In MATLAB, open 'wave_gui.m' in the editor and run the program. A MATLAB figure should open that looks approximately like the one below.

![Newly opened wave analyzer gui in matlab as of 2018-07-16.](./blank_gui_20180716.png?raw=true "Example GUI")

4. Set the appropriate calibration value to convert your data from voltage to pressure (Default: 0.022 V/MPa for Onda HGL-0200 hydrophone). Set this to 1.0, if your data is already a time-pressure series.
5. Select the appropriate input data set by finding the 'Input Wave CSV File' and clicking the folder icon to the right of this box to open a graphical interface to choose your input data set. Alternately, type the file path in the box labeled 'Input Wave CSV File' and click the button labeled 'Load/Reset'. This should load the input data, plot the pressure waveform, and run a pulse analysis on the entire waveform. If the choose the sample data set 'example_input_data.csv' the gui should look like the figure below. If no MATLAB errors have been produced, then you have successully run the gui.

![Newly opened wave analyzer gui in matlab as of 2018-07-16.](./example_gui_20180716.png?raw=true "Example GUI")

### Prerequisites

1. MATLAB : This project was developed and tested in MATLAB 2018a. Older versions of MATLAB may work, but have not been tested.
2. Microsoft Excel (optional) : This function has the ability to export processed data and figures to a '.xlsx' format. To open these, Microsoft excel or another capable program (e.g., google sheets) may be necessary.

## Using the wave analyzer.  The wave analyzer was created originally
created to take raw hydrophone recordings of ultrasound pressure waves
and analyze the data to extract and display acoustic quantities
relevant to diagnostic ultrasound bioeffects (e.g., frequency content,
intensity, mechanical index, etc...). The analysis performed is
largely based on linear acoustics and as such, is imperfect for most
ultrasound waves, which are typically nonlinear. However, this tool
should provide a decent approximation for researchers and inquiring
minds. For any reported quantities denoted by 510(k), the exact
definition of the quantities can be found in the FDA's 2008 510(k)
guidelines. Other methods used in the analysis and relevant references
should be detailed thoughout this document, but if something is
missing, feel free to check out the code or contact the author.

The wave analyzer has a variety of features and functions to try to
make it easy to extact information about useful acoustic quantities
from raw hydrophone measurements. To explain these features, the various components of the wave analyzer's graphical user interface (GUI) 
been numbered and explained in the figure below and subsequent
paragraphs for an example case.
![Newly opened wave analyzer gui in matlab as of
2018-07-16.](./numbered_gui_20180716.png?raw=true "Example GUI")

1. Input filepath box, browse button, 'Load / Reset' button.  * The
Input filepath box contains the filepath to the .csv file which
contains timeseries data of the measured hydrophone voltage. This can
be typed manually or selected with a filebrowser by clicking the
browse button (i.e., button with the folder icon to the
right). Choosing a dataset using the filebrowser will automatically
load the dataset. NOTE: The raw voltage in the input .csv file will be
converted to pressure using conversion coeffiecient in the calibration
box (see 2.)  * The 'Load / Reset' button will load the dataset that
is indicated in the Input filepath box. If chosen dataset is already
loaded, this button will reset any analysis and plots that have been
created to their original state.  * Loading a dataset though either
method (e.g., using the filebrowser or typing the path and clicking
'Load / Reset'), will automatically plot and analyze the data. The
analysis will use the upper and lower time bounds of the data as right
and left pulse boundaries respectively.  * Depending on the computer
and size of the dataset, this may take several seconds.

2. Calibration box
* The value specified here is used to convert the voltage in the csv file to pressure.
* The units are Volts / MPa.
* The default value is 0.022 V/MPa. This is based on an Onda HGL-0200 transducer.

3. Data plot
* A plot of the chosen acoustic quanitity from the timeseries data is shown here.
* Pressure (MPa) vs time (us) is the default plot. Intensity (W/cm^2) vs time (us), and frequency content (fft) can also be plotted.

4. Plot picker
* Select the radio button of the quanitity you wish to plot (Pressure, Intensity, FFT).

5. Plot tools

6. Pulse boundaries

7. Pulse analysis

8. Pulse derating

9. Export data


## Acoustic quantities and calculations
* Pressure
* Intensity is calculated for an acoustic signal recorded in water (density = 1000 kg/m^3, sound speed = 1500 m/s), assuming linear acoustic relationships (acoustic velocity = acoustic pressure / acoustic impedance). Where acoustic impedance = density*sound speed. Intensity = pressure^2 / (density*sound speed). See Fundamentals of Acoustics by Kinsler et al. for more information.
* Fast Fourier Transform:
* Maximum pressure, P+ (MPa):
* Minimum pressure (e.g., peak rarefaction pressure amplitude (PRPA)), P- (MPa):
* Center pressure, <p> (MPa):
* Pulse average Intensity, Ipa (W/cm2):
* Center frequency, fc (MHz):
* Mechanical Index, MI:
* Derated pressure (MPa):
* Attenuation coefficient (dB/cm/MHz):
* Depth (cm):

## Deployment Notes

* This was developed and tested on MATLAB 2018a using guide. Forward or backward compatibility not guaranteed.
* This was created to work with .CSV files output from a tektronix MDO3052 Mixed Domain Oscilloscope. For other input formats, change 'read_input_data.m' to read your dataset such that it produces two vector outputs: time and voltage. Output values must be real and finite. The first output variable, 'time', must contain unique, monotonically increasing values containing the times (in seconds) at which the voltage measurements are taken. The second output, 'voltage' must contain the voltage measurements at each time value. Here, voltage is pressure (MPa) times calibration (V/MPa), such that if the input is already in units of pressure (MPa), the calibration value should be changed to 1.0 (V/MPa). 
* The base calibration value of 0.022 MPa / MHz is for an ONDA HGL-0200 "Golden Lipstick" Hydrophone. This should be changed for input data measured using other devices. See your hydrophone documentation for details.

## To Do:
* Fix bug where pulse bounds don't adjust y-values when switching from Intensity to pressure.
* Fix bug: Reset plot picker radio button to pressure when new data is loaded.
* Improve plot readability: bold Axis labels or increase font size
* Fix bug: FFT crashes for certain well resolved waves. Note: Cal3-tek0006.

## Built With

* MATLAB using the 'guide' gui creator. 

## Contributing

Interested in contributing to this project. Contact me via github or at i.am.brandon.patterson@gmail.com


## Authors

* **Brandon Patterson** - *Initial work* - [bspatter](https://github.com/bspatter)



## License



## Acknowledgments
* Brian Worthmann for the very useful bfft.m and bifft.m functions
* Michelle Hirsch for the xlswritefig function - https://www.mathworks.com/matlabcentral/fileexchange/24424-xlswritefig.
* Billie Thompson for the gitub README-Template - https://gist.github.com/PurpleBooth/109311bb0361f32d87a2
