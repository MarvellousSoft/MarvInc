# Classes
Place here classes files

*Primitive.lua* aleardy contain several base classes to inherit from. Create separate files for specific classes, but try to surpress code by inheriting primitive classes. More info:

**ELEMENT**:
Basic class that can have a type, subtype and id, used mostly for drawing.
It also has two extra atributes: exception and invisible
 - Use type for generic class type, like "button", "player" or "boss"
 - Use subtype to further classify elements, like "GUI" or "walls".
 - Use id to specify an unique element like "David Robert Jones" or "Excalibur".
 - Exception is used when clearing tables (if true, the object will not be removed)
 - Invisible is used when drawing the object (if true, the object will not be drawn)
 You can use useful methods such as:
 - setId() or setSubTp() to set the correspondent identificator to this element, and also add him to auxiliary tables (one for subtypes, another for elements with id) so that the object can be quickly found later.
 - destroy() to

 **POS**, **CLR**, **WTXT**:
Characteristics one element can have, such as position, color or "with-text".

**RECT**, **CIRC**:
Simple rectangle and circle.


Add/edit more characteristics/shapes/whatever you desire. If in doubt on how to use HUMP classes, check here:
http://hump.readthedocs.io/en/latest/class.html
