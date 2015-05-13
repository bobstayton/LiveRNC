# LiveRNC
A LiveRNC is a Compact Relax NG schema converted into a hypertext document. It is also a perl program (livernc.pl) that performs that conversion. It parses the schema files and generates a copy with HTML markup inserted. The result is the exact same text of the original schema, but with live links that let you navigate through the schema. Click on a name, and you are transported to where that name is declared in the schema. Both elements and named patterns are hot linked.

For a simple schema, this may not be very useful. But for complex schemas like DocBook and DITA that use hundreds of elements and patterns, it's a great help. If you have to maintain a customization layer for such a schema, it is priceless (good thing it's free). 

See its cousin [LiveDTD](http://www.sagehill.net/livedtd/) for details on how this works.
