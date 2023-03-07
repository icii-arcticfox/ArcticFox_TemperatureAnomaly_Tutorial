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


/*[$TemperatureWidth 16]*/

//****************************************************
//***************  Receive Temperature  **************
//****************************************************
/*[RisingEdge]*/
wire risingScl;

/*[SerialShifter --width $TemperatureWidth --risingAccept scl --data sda]*/
reg [/*[$TemperatureWidth]*/ - 1:0] receivedTemperature;

/*[Counter --count $TemperatureWidth --event $scl.rising]*/
reg [15:0] sclCounter;

/*[$temperatureReceived $sclCounter.done]*/



//****************************************************
//******************  Track Last n  ******************
//****************************************************
/*[$TemperaturesToTrack 16]*/

/*[Expand --count $TemperaturesToTrack]*/ reg [15:0] temperatureHistory;

/*[VariableShifter --dataBase temperatureHistory --incoming receivedTemperature --count $TemperaturesToTrack --risingAccept acceptTemperature]*/



//****************************************************
//**********  Calculate Average Temperature  *********
//****************************************************
/*[Sum --base temperatureHistory --count $TemperaturesToTrack]*/
wire [31:0] temperatureSum;

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
wire [15:0] eigthOfAverageTemperature;
assign eigthOfAverageTemperature = averageTemperature >> 3;

reg [15:0] upperTemperatureBound;
//Use an always automation
/*[always upperTemperatureBound]*/ begin
    //A Reset automation
    /*[Reset]*/
        //Non blocking automation to set upperTemperatureBound to 0
        /*[<= 0]*/
    else
        //Another non blocking automation to set
        //upperTemperatureBound to averageTemperature + eigthOfAverageTemperature
        /*[<= averageTemperature + eigthOfAverageTemperature]*/
end

reg [15:0] lowerTemperatureBound;
/*[always lowerTemperatureBound]*/ begin
    /*[Reset]*/
        /*[<= 0]*/
    else
        /*[<= averageTemperature - eigthOfAverageTemperature]*/
end



//****************************************************
//*************  Determine When to Accept  ***********
//****************************************************
/*[Counter --event $temperatureReceived --noMax]*/
reg[7:0] temperaturesReceived;

wire acceptTemperature;
assign acceptTemperature =
        /*[$temperatureReceived]*/
        &&
        (
            (temperaturesReceived < /*[$TemperaturesToTrack]*/ )
            ||
            (
                receivedTemperature > lowerTemperatureBound
                && receivedTemperature < upperTemperatureBound
            )
        )
        ;



//****************************************************
//*******************  Set Outputs  ******************
//****************************************************
/*[always temperatureReady]*/ begin
    /*[Reset]*/
        //Set to 0
        /*[<= 0]*/
    else if(acceptTemperature)
        //Set to 1
        /*[<= 1]*/
    else
        //Set to 0
        /*[<= 0]*/
end

/*[always temperature]*/ begin
    /*[Reset]*/
        //Set to 0
        /*[<= 0]*/
    else if(acceptTemperature)
        //Set to receivedTemperature
        /*[<= receivedTemperature]*/
    else
        //Hold value
        /*[<=]*/
end



endmodule