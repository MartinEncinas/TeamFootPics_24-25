Authored by team FootPics through the 24 to 25 University of Arizona school year for the senior capstone.
Any questions can be forwarded to martinencinas@arizona.edu or 760-996-8076
The Front end component is written in Matlab
The Back end components are written in Matlab with C++ being the language of choice for our arduino subsystem

---------------------------------------------------

The Arduino controls two different subsystems and is used to communicate with the backend of matlab through serial communication 
Subsystem 1 is the Motor assembly using stepper motors
Subsystem 2 are the load cells

---------------------------------------------------

The matlab code interacts with both the arduino and a verasonics system to interpret load cell information recieved from the arduino and IQ form data from the verasonics hardware.

Currently once the verasonics IQ data is intercepted by our matlab code it calculates the envelope and finds a velocity estimate using the difference in position of the ultrasound propogation.
That is the envelope mentioned which will be divided by time. Time is found using the speed of sound of 1540 m/s which is converted to time using wavelength found through the division of 1 by frequency in hz.
Frequency is queried by the matlab software on the hardware since it is variable based on user settings. Usually it is in MHz.
