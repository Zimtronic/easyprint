# easyprint template engine

easyprint is a template engine whose goal is to reduce the work to 
use the ESCPOS printer in [posjs](https://github.com/Zimtronic/posjs) and 
[posjs2](https://github.com/Zimtronic/posjs2) projects.

A short list of the features:

 * Simple syntax
 * Highly configurable
 * Extensible via [jison](http://zaach.github.io/jison/docs) grammar.

### Syntax

A template contains variables or expressions, which get replaced with values when 
the template is evaluated, and tags, which control the logic of the template. 
Below is a minimal template that illustrates a few basics. We will cover further 
details later on:  :+1:

```javascript
{{image:imagePath}} \
.style1 Template {{var:title}} .newline \
.style2 STORE # {{var:storeNumber}} .newline \
{{var:storeCity}} .newline \
.style5 \
{{map:headerMap}} \
.hline \
{{map:pricesMap}} \
.hline \
{{map:resultMap}} \
{{barcode:code}} \
{{qrcode:code}} \
.style3 Thanks >>>
```

#### Text styles
```javascript
.style1 .style2 .style3 .style4 .style5
```
#### Print a new line
```javascript
.newline
```
#### Print horizontal line
```javascript
.hline
```
#### Print variables or expressions
Print the content of variables or the result of evaluating an expression.
```javascript
{{type:id}}
```
We defined six variable types ***var, list, map, image, barcode, qrcode***. 
The correspondent *id* must be an javascript variable identifier as follow:

* var -> js var id of type string, int or float
* list -> js var id of type Array
* map -> js var id of type bidimentional Array
* image -> js var id of type string with the path to a local image
* barcode -> js var id of type string with an ascii code
* qrcode -> js var id of type string with an ascii code

### Using easyprint 
```javascript
<html>
    <head>
        <script src="easyprint.js"></script>
        <script>
        
        var title = "TEST";
        var products = ["milk", "banana", "beans"];
        var headerMap = [["Products", "Price"]];
        var pricesMap = [["milk", 10.50],["banana", 5.40], ["beans", 20.60]];
        var resultMap = [["Subtotal", 10.50],["Tax 10%", 5.40], ["Total", 20.60], ["Cash tend", 8.5], ["Cash due", 10.20]];
        var code = "ZIMTRONIC";
        var imagePath = ":/zimtronic-pos.png";
        var storeNumber = 0123456;
        var storeCity = "MIAMI BEACH, FL."
        
        var source = "{{image:imagePath}} \
                      .style1 Template {{var:title}} .newline \
                      .style2 STORE # {{var:storeNumber}} .newline \
                      {{var:storeCity}} .newline \
                      .style5 \
                      {{map:headerMap}} \
                      .hline \
                      {{map:pricesMap}} \
                      .hline \
                      {{map:resultMap}} \
                      {{barcode:code}} \
                      {{qrcode:code}} \
                      .style3 Thanks >>>";
        
        function test(){
            var template = new EasyPrintTemplate(source);
            template.render();
        }

        </script>
    </head>
    <body>
        <form name="form1">
            <input type="button" onclick="test()"value="Render">

        </form>
    </body>
</html>
```
