### Example for library ###
This is an example of Rails server code that saves attachment
uploaded via ajax with fileuploaded.js library.

This code doesn't work at the moment properly with Safari,
unless you specify a Content-Type in fileuploaded.js library.
To do this add the following line:
xhr.setRequestHeader("Content-Type", "application/octet-stream");

just before xhr.send(file).

You should have the following:

xhr.open("POST", this._options.action + queryString, true);
xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
xhr.setRequestHeader("X-File-Name", encodeURIComponent(name));
xhr.setRequestHeader("Content-Type", "application/octet-stream");
xhr.send(file);