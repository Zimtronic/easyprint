
/* description: posjs template. */

%{
    if(typeof ESCPOSPrinter != "undefined"){
        ESCPOSPrinter.init();
    }

    var printerBuff = "";
    var lineLength = 48;
    
    function printBuffer(){
        
        if(printerBuff != ""){
            if(typeof ESCPOSPrinter != "undefined"){
                ESCPOSPrinter.printRawText(printerBuff);
                ESCPOSPrinter.feedControl(0);
            }
            else
              console.log("ESCPOSPrinter is not defined...");
        }
        else
            console.log("printerBuffer is empty...");
        
        printerBuff = "";
    }
%}

/* lexical grammar */
%lex
%%

[a-zA-Z_0-9]+(":"[a-za-zA-Z_0-9]+)?\b   return 'ID'
".style1"                               return 'STYLE1'
".style2"                               return 'STYLE2'
".style3"                               return 'STYLE3'
".style4"                               return 'STYLE4'
".style5"                               return 'STYLE5'
"{{"                                    return 'IDLEFT'
"}}"                                    return 'IDRIGHT'
".newline"                              return 'NEWLINE'
".hline"                                return 'HLINE'
">>>"                                   return 'CUT'
<<EOF>>                                 return 'EOF'
.                                       return 'EXTRA'


/lex

%% /* language grammar */
input:
   %empty
   | input line
   ;

line:
   EOF
        {
            console.log("EOF");
            
            printBuffer();
        }
   | NEWLINE
        {
            console.log("NEWLINE");
            
            printerBuff += " ";
            printBuffer();
        }
   | content line
   ;

content: 
    ID
        {
            console.log("ID");
            
            printerBuff += $1;
        }
    | EXTRA
        {
            console.log("EXTRA");
            
            printerBuff += $1;
        }
    | STYLE1
        {
            console.log("STYLE1");
            
            lineLength = 24;
            if(typeof ESCPOSPrinter != "undefined"){
                ESCPOSPrinter.setTextProperties(0,0,4,2,2);
            }
            else
                console.log("ESCPOSPrinter is not defined...");
        }
    | STYLE2
        {
            console.log("STYLE2");
            
            lineLength = 48;
            if(typeof ESCPOSPrinter != "undefined"){
                ESCPOSPrinter.setTextProperties(1,1,2,1,2);
            }
            else
                console.log("ESCPOSPrinter is not defined...");
        }
    | STYLE3
        {
            console.log("STYLE3");
            
            lineLength = 24;
            if(typeof ESCPOSPrinter != "undefined"){
                ESCPOSPrinter.setTextProperties(1,1,1,2,1);
            }
            else
                console.log("ESCPOSPrinter is not defined...");
        }
    | STYLE4
        {
            console.log("STYLE4");
    
            lineLength = 48;
            if(typeof ESCPOSPrinter != "undefined"){
                ESCPOSPrinter.setTextProperties(0,1,0,1,1);
            }
            else
                console.log("ESCPOSPrinter is not defined...");
        }
    | STYLE5
    {
        console.log("STYLE5");
        
        lineLength = 48;
        if(typeof ESCPOSPrinter != "undefined"){
            ESCPOSPrinter.setTextProperties(2,0,0,1,1);
        }
        else
            console.log("ESCPOSPrinter is not defined...");
    }
    | IDLEFT ID IDRIGHT
        {
            console.log("IDLEFT ID IDRIGHT");
            
            var stringPair = $2;
            
            var stringList = stringPair.split(":");
            
            if(stringList.length == 2){
                
                if(stringList[0] == "var"){
                    printerBuff += eval(stringList[1]);
                }
                else if(stringList[0] == "list"){
                    list = eval(stringList[1]);
                    printBuffer();
                    
                    for (var i = 0; i < list.length; i++){
                        console.log(list[i]);
                        printerBuff += list[i];
                        printBuffer();
                    }
                }
                else if(stringList[0] == "map"){
                    map = eval(stringList[1]);
                    printBuffer();
                    
                    for (var i = 0; i < map.length; i++){
                        var1 = map[i][0].toString();
                        var2 = map[i][1].toString();
                        
                        console.log(var1+" ---------- "+var2);
                        
                        printerBuff += var1;
                        len = lineLength - (var1.length + var2.length);
                        for (var j = 0; j < len; j++)
                            printerBuff += " ";
                        
                        printerBuff += var2;
                        printBuffer();
                    }
                }
                else if(stringList[0] == "barcode"){
                    code = eval(stringList[1]);
                    printBuffer();
                    
                    if(typeof ESCPOSPrinter != "undefined"){
                        ESCPOSPrinter.feedControl(0);
                        ESCPOSPrinter.printBarcode(code, 69, 2, 50, 2, 1);
                        ESCPOSPrinter.feedControl(0);
                    }
                    else
                        console.log("ESCPOSPrinter is not defined...");
                }
                else if(stringList[0] == "qrcode"){
                    code = eval(stringList[1]);
                    printBuffer();
                    
                    if(typeof ESCPOSPrinter != "undefined"){
                        ESCPOSPrinter.feedControl(0);
                        ESCPOSPrinter.printQRCode(code, 51, 3);
                        ESCPOSPrinter.feedControl(0);
                    }
                    else
                        console.log("ESCPOSPrinter is not defined...");
                }
                else if(stringList[0] == "image"){
                    path = eval(stringList[1]);
                    printBuffer();
                    
                    if(typeof ESCPOSPrinter != "undefined"){
                        ESCPOSPrinter.feedControl(0);
                        ESCPOSPrinter.printImage(path, 1, 15);
                        ESCPOSPrinter.feedControl(0);
                    }
                    else
                        console.log("ESCPOSPrinter is not defined...");
                }
                else
                    console.log("Invalid ID...");
            }
            else
                console.log("Invalid ID...");
        }
    | HLINE
        {
            console.log("HLINE");
            
            if(typeof ESCPOSPrinter != "undefined"){
                ESCPOSPrinter.feedControl(0);
                var buff = "";
                for (var i = 0; i < lineLength; i++)
                    buff += "-";
                ESCPOSPrinter.printRawText(buff);
                ESCPOSPrinter.feedControl(0);
            }
            else
                console.log("ESCPOSPrinter is not defined...");
        }
    | CUT
        {
            console.log("CUT");
            
            printBuffer();
            
            if(typeof ESCPOSPrinter != "undefined"){
                ESCPOSPrinter.feedControl(0);
                ESCPOSPrinter.feedControl(0);
                ESCPOSPrinter.feedControl(0);
                ESCPOSPrinter.cutPaper();
            }
            else
                console.log("ESCPOSPrinter is not defined...");
        }
    ;

