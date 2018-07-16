# Wave_analyzer

Tools and GUI for analyzing recorded ultrasound waves.

## Getting Started

To get the ultrasound wave analyzer running, take the following steps:
1. Download or git clone the 'wave_analyzer' repository to your local computer.
1. In MATLAB, navigate to the newly created 'wave_analyzer' directory.
1. In MATLAB, open 'wave_gui.m' in the editor and run the program. A MATLAB figure should open that looks approximately like the one below.

![Newly opened wave analyzer gui in matlab as of 2018-07-16.](./blank_gui_20180716.png?raw=true "Example GUI")

1. Set the appropriate calibration value to convert your data from voltage to pressure (Default: 0.022 V/MPa for Onda HGL-0200 hydrophone). Set this to 1.0, if your data is already a time-pressure series.
1. Select the appropriate input data set by finding the 'Input Wave CSV File' and clicking the folder icon to the right of this box to open a graphical interface to choose your input data set. Alternately, type the file path in the box labeled 'Input Wave CSV File' and click the button labeled 'Load/Reset'.

This should load and plot the pressure waveform from the imported data.
1. 

### Prerequisites

1. MATLAB : This project was developed and tested in MATLAB 2018a. Older versions of MATLAB may work, but have not been tested.
2. Microsoft Excel (optional) : This function has the ability to export processed data and figures to a '.xlsx' format. To open these, Microsoft excel or another capable program (e.g., google sheets) may be necessary.

```
Give examples
```

### Installing

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

* This was developed and tested on MATLAB 2018a using guide. Forward or backward compatibility not guaranteed.
* This was created to work with .CSV files output from a tektronix MDO3052 Mixed Domain Oscilloscope. For other input formats, changes to the code will be required.
* The base calibration value of 0.022 MPa / MHz is for an ONDA HGL-0200 "Golden Lipstick" Hydrophone. This should be changed for input data measured using other devices. See your hydrophone documentation for details.

## Built With

* MATLAB using the 'guide' gui creator. 

## Contributing

Interested in contributing to this project. Contact me via github or at i.am.brandon.patterson@gmail.com


## Authors

* **Brandon Patterson** - *Initial work* - [bspatter](https://github.com/bspatter)



## License



## Acknowledgments
Brian Worthmann for the very useful bfft.m and bifft.m functions
Michelle Hirsch for the xlswritefig function - https://www.mathworks.com/matlabcentral/fileexchange/24424-xlswritefig.
Billie Thompson for the gitub README-Template - https://gist.github.com/PurpleBooth/109311bb0361f32d87a2
