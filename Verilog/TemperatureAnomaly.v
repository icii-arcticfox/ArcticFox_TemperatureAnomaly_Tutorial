module TemperatureAnomaly(
    /*[Clock 100 MHz]*/
    input clk,

    /*[Reset]*/
    input reset,

    input sda, //Incoming serial data line
    input scl, //Incoming serial clock

    output reg temperatureReady,  //Signal indicating the temperature value is valid
    output reg [/*[$TemperatureWidth]*/ - 1:0] temperature //Output temperature once its been accepted
);


//First, let's set a Value for the bit width of the temperature signal
/*[$TemperatureWidth 16]*/

//****************************************************
//***************  Receive Temperature  **************
//****************************************************
//First, we need to translate the incoming serial data into a parallel number
//We've already setup the automations for the section

//We will sample data on the rising edge of the serial clock,
//So let's get the rising edge of scl
//Here, we don't specify the source, but we instead rely on the
//notation of the rising prefix in the wire name
/*[RisingEdge]*/
wire risingScl;

//Now, let's shift the serial data into a parallel reg, the
//SerialShifter automation will store --width bits from the
//--data source everytime the --risingAccept signal rises
/*[SerialShifter --width $TemperatureWidth --risingAccept scl --data sda]*/
reg [/*[$TemperatureWidth]*/ - 1:0] receivedTemperature;

//We need to know when a full value has been received. Let's
//count the number of scl rises to know when we have received a
//total of $TemperatureWidth scl rises
/*[Counter --count $TemperatureWidth --event $scl.rising]*/
reg [15:0] sclCounter;

//Finally, $sclCounter.done does not descire what we are trying
//to discern, we are trying to discern when we've received a full
//temperature reading. Let's make a Value that copies $sclCounter.done
//and gives it a better name
/*[$temperatureReceived $sclCounter.done]*/



//****************************************************
//******************  Track Last n  ******************
//****************************************************
//_***Step 1a) Now, we need to keep the previous n accepted temperature values so we can
//_***calculate the average. Lets create a Value for the number of temperatures to track.
//_***Let's start by using 16 for the Value
//_***doc: https://tinyurl.com/af-setvalue
/*[$TemperaturesToTrack ???]*/

//_***Step 1b) Next, lets create the registers to hold the last n temperatures
//_***Let's use the following reg, temperatureHistory, except we need $TemperaturesToTrack
//_***of them. We recommend using the Expand automation
//_***doc: https://tinyurl.com/af-expand
reg [15:0] temperatureHistory;

//_***Step 1c) Then, similar to the SerialShifter, we need to shift new temperatures values through
//_***the regs we made. We recommend using the VariableShifter automation. You'll likely
//_***want to set the dataBase to temperatureHistory, incoming to receivedTemperature, 
//_***coutn to the Value for temperatures to track, and risingAccept to acceptTemperature
//_***doc: https://tinyurl.com/af-serialshifter


//_***Continue to Step2_AverageTemperature


endmodule