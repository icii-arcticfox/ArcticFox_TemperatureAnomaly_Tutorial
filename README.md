# Temperature Anomaly - Arctic Fox Tutorial

<p align="center">
    <img src="https://icii.io/wp-content/uploads/2022/09/New-Arctic-Fox-Logo.Blue_.For-Animation.WithBehindForGaps-1.svg" alt="Arctic Fox Logo" style="width:300px;"/>
</p>

This repo is a tutorial that implements anomaly detection for a temperature sensor. The sensor receives temperature readings and detmerines when a reading is anomolous. In this tutorial you will dive deeper into using automations within a Verilog module. 
<br>

# Setup
Refer to <a href="https://github.com/icii-arcticfox/TutorialHome#how-to-use-tutorials/" target="_blank">Tutorial How To</a> to start the tutorial. 

# Description
Continuing from our Debounce tutorial, again, many signals are noisy and require filtering. Another example of this is anomalies. Anomalies can arise for a variety of reasons - a sensor’s software momentarily failed, the communication medium flipped a bit, you read a register too quickly, etc. It’s important to be able to detect anomalies and discern how to handle the anomaly.  

For this tutorial, we will imagine that we have are receiving data from a temperature sensor. When the sensor is behaving as expected, we should see data like that below. This sensor is reading between 93.5 and 95.5 (it’s a low-quality sensor 😛) but is staying rather consistent. And, we’ll assume it has been placed outside on a summer day.

<div style="width:100%;text-align:center;">
<img src="https://icii.io/wp-content/uploads/2023/02/Temperature-Readings-Over-Time.png"  style="max-width:600px">
</div>

<br/>
<br/>
However, in the event of anomaly, we may see a random spike in the data. You can see this in the graph below. If we used this value in our calculations it could greatly skew the results. 

<div style="width:100%;text-align:center;">
<img src="https://icii.io/wp-content/uploads/2023/02/Temperature-Readings-Over-Time-with-Anomaly.png"  style="max-width:600px">
</div>

<br/>
<br/>
So, what do we do? In this tutorial we will take simple approach and throw out anomalies. We will keep a running average of the received temperature readings and when a reading a too far from the average, we will throw it out. 

# Steps
The tutorial contains the following steps in the following files: 
- Verilog/TemperatureAnomaly.v
  - Steps 1, 2, 3, 4
- Verilog/Test/TemperatureAnomalyTest.v 
  - Step 5

# Solution
As you proceed through the tutorial, the correct code for previous steps will be given. 