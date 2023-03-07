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
//***Step 1a) Now, we need to keep the previous n accepted temperature values so we can
//***calculate the average. Lets create a Value for the number of temperatures to track.
//***Let's start by using 16 for the Value
/*[$TemperaturesToTrack 16]*/

//***Step 1b) Next, lets create the registers to hold the last n temperatures
//***Let's use the following reg, temperatureHistory, except we need $TemperaturesToTrack
//***of them. We recommend using the Expand automation
/*[Expand --count $TemperaturesToTrack]*/ reg [15:0] temperatureHistory;

//***Step 1c) Then, similar to the SerialShifter, we need to shift new temperatures values through
//***the regs we made. We recommend using the VariableShifter automation. You'll likely
//***want to set the dataBase to temperatureHistory, incoming to receivedTemperature, 
//***coutn to the Value for temperatures to track, and risingAccept to acceptTemperature
/*[VariableShifter --dataBase temperatureHistory --incoming receivedTemperature --count $TemperaturesToTrack --risingAccept acceptTemperature]*/



//****************************************************
//**********  Calculate Average Temperature  *********
//****************************************************
//Now we need to calculate the average of the saved temperature readings.
//If n is a power of 2, we can easily do it by summing the temperatureHistory regs,
//and right shifting the sum

//***Step 2) Lets sum up all of the temperatureHistory regs. We recommend using the Sum
//***automation. Please note, the Sum automation is a non optimal way to add these
//***regs, due to the amount, but it's easy to use for the tutorial
/*[Sum --base temperatureHistory --count $TemperaturesToTrack]*/
wire [31:0] temperatureSum;

//Now, let's right shift the sum to divide it and get the average
parameter rightShiftsForAverageDividend = $clog2(/*[$TemperaturesToTrack]*/);
reg [15:0] averageTemperature;
/*[always averageTemperature]*/ begin
    /*[Reset]*/
        /*[<= 0]*/
    else
        /*[<= temperatureSum >> rightShiftsForAverageDividend]*/
end



//****************************************************
//************  Calculate Average Bounds  ************
//****************************************************
//Next, we need to determine the upper and lower bound of temperatures that the
//current average will accept. To do this, we will make the upper bound
//the average + 1/8th, and the lower bound the average - 1/8th

//To get 1/8 of the average, just right shift by 3
wire [15:0] eigthOfAverageTemperature;
assign eigthOfAverageTemperature = averageTemperature >> 3;

//_***Step 3a) Now, let's calcuate the upper bound in an always block to give a little
//_***pipelining. Follow the example of the always block above, the block for
//_***average temperature, to create an automation-ized always block for
//_***the upperTemperatureBound reg.
//_***docs: 
//_***      https://tinyurl.com/af-always
//_***      https://tinyurl.com/af-nonblocking
reg [15:0] upperTemperatureBound;
//5a) Use an always automation
/*[???]*/ begin
    //5b) A Reset automation
    /*[???]*/
        //5c) Non blocking automation to set upperTemperatureBound to 0
        /*[??? 0]*/
    else
        //5d) Another non blocking automation to set
        //    upperTemperatureBound to averageTemperature + eigthOfAverageTemperature
        /*[??? averageTemperature + eigthOfAverageTemperature]*/
end

//_***Step 3b) Now, do the same for the lowerTemperatureBounce. It should be the same
//_***as the upperTemperatureBound, but you want to subtract eigthOfAverageTemperature.
//_***Also, you will need to create the always automation/block without guidance here.
reg [15:0] lowerTemperatureBound;
/*[???]*/ begin
    /*[???]*/
        /*[???]*/
    else
        /*[???]*/
end


//_***Continue to Step4_AcceptAndOutputs



endmodule