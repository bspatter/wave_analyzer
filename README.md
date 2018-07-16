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

## Using the wave analyzer.
The wave analyzer has a variety of useful features and functions. To explain these features, they have been numbered and explained in the figure below and subsequent paragraphs.
![Newly opened wave analyzer gui in matlab as of 2018-07-16.](./numbered_gui_20180716.png?raw=true "Example GUI")

## Deployment Notes

* This was developed and tested on MATLAB 2018a using guide. Forward or backward compatibility not guaranteed.
* This was created to work with .CSV files output from a tektronix MDO3052 Mixed Domain Oscilloscope. For other input formats, change 'read_input_data.m' to read your dataset such that it produces two vector outputs: time and voltage. Output values must be real and finite. The first output variable, 'time', must contain unique, monotonically increasing values containing the times (in seconds) at which the voltage measurements are taken. The second output, 'voltage' must contain the voltage measurements at each time value. Here, voltage is pressure (MPa) times calibration (V/MPa), such that if the input is already in units of pressure (MPa), the calibration value should be changed to 1.0 (V/MPa). 
* The base calibration value of 0.022 MPa / MHz is for an ONDA HGL-0200 "Golden Lipstick" Hydrophone. This should be changed for input data measured using other devices. See your hydrophone documentation for details.


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
