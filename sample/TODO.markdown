Todo
====
 
1. Authentication credentials:  Where should they be stored?  How should they be protected.  Google CL stores authentication info the first time it is run. However googlecl is limited since they only thing it can do is create,get, and list docs.  Docs can be opened with an editor but to do any programatic transformations on the data the http api must be used for google docs.  I'm in the process of wrapping as much functionality as we can get from scripting google cl into ruby classes and building some classes for the http api. 


2.	Next step is to edit a series of cells to add a grade in one category for each student.	