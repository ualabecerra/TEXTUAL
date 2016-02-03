## TEXTUAL

The goal of the project is the testing of XQuery programs. A tool called __TEXTUAL__ has been implemented in order to test XQuery programs. The tool is based on the ideas shown in the following papers:

* Jesús Manuel Almendros-Jiménez, Antonio Becerra Terón. _XQuery Testing from XML Schema Based Random Test Cases_. Proceedings of DEXA (2) 2015, pp. 268-282 [PDF](http://textualtesting.cloudapp.net/textual/Papers/Dexa2015.pdf)
* Jesús Manuel Almendros-Jiménez, Antonio Becerra Terón. _Automatic Validation of XQuery Programs_. 
Proceedings of iiWAS 2015 [PDF](http://textualtesting.cloudapp.net/textual/Papers/iiWAS2015.pdf)

__TEXTUAL__ takes the following inputs:

+ an _XML Schema_ (you can choose one of the list, edit it or write down a new one), e.g., schema01.xsd,
+ an _XQuery program_ to be tested,
+ an _input property_, e.g., 
+ an _XQuery function_ representing the input property to be tested w.r.t. the above query, e.g., 

~~~
$book/price < 100,
~~~

+ an output property, e.g., a XQuery function representing the output property to be tested w.r.t. the above query, e.g., 

~~~
every $result in $results/* satisfies contains($result/text(),"XML"),
~~~

+ an input-output property, e.g., a XQuery function representing the input-output property to be tested w.r.t. the above query, e.g., 

~~~
every $title in $results/* satisfies every $f in $file//(chapter | section)/title satisfies not($title/text()=$f/text()) 
~~~

+ a number of steps in test case generation, e.g., 2

Please let me know if you have any question or comment to [jalmen@ual.es](mailto:jalmen@ual.es)