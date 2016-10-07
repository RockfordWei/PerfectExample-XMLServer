# Perfect Example XML Server [简体中文](README.zh_CN.md)

<p align="center">
    <a href="http://perfect.org/get-involved.html" target="_blank">
        <img src="http://perfect.org/assets/github/perfect_github_2_0_0.jpg" alt="Get Involed with Perfect!" width="854" />
    </a>
</p>

<p align="center">
    <a href="https://github.com/PerfectlySoft/Perfect" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_1_Star.jpg" alt="Star Perfect On Github" />
    </a>  
    <a href="https://gitter.im/PerfectlySoft/Perfect" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_2_Git.jpg" alt="Chat on Gitter" />
    </a>  
    <a href="https://twitter.com/perfectlysoft" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_3_twit.jpg" alt="Follow Perfect on Twitter" />
    </a>  
    <a href="http://perfect.ly" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_4_slack.jpg" alt="Join the Perfect Slack" />
    </a>
</p>

<p align="center">
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat" alt="Swift 3.0">
    </a>
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat" alt="Platforms OS X | Linux">
    </a>
    <a href="http://perfect.org/licensing.html" target="_blank">
        <img src="https://img.shields.io/badge/License-Apache-lightgrey.svg?style=flat" alt="License Apache">
    </a>
    <a href="http://twitter.com/PerfectlySoft" target="_blank">
        <img src="https://img.shields.io/badge/Twitter-@PerfectlySoft-blue.svg?style=flat" alt="PerfectlySoft Twitter">
    </a>
    <a href="https://gitter.im/PerfectlySoft/Perfect?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge" target="_blank">
        <img src="https://img.shields.io/badge/Gitter-Join%20Chat-brightgreen.svg" alt="Join the chat at https://gitter.im/PerfectlySoft/Perfect">
    </a>
    <a href="http://perfect.ly" target="_blank">
        <img src="http://perfect.ly/badge.svg" alt="Slack Status">
    </a>
</p>
Perfect XML Example Project

This repository demonstrates how to manipulate XML api in a Perfect HTTP Server. It currently contains most of the DOM Core level 2 *read-only* APIs and includes XPath support.

## Setup

Before start this demo, please make sure Swift 3.0 or later version has already installed properly on your system. Please check [Swift 3.0 Installation Guide] (http://swift.org) for detail.


## Quick Start

The general idea of this example is to build an HTTP Server to show data extracted from an XML string. In another word, if you treat XML as a database, then PerfectXML will be the database connector and XPath will be the query language. You can download this example for a quick start:

```bash
git clone https://github.com/PerfectlySoft/PerfectExample-XML.git
```

or if you can start it from a blank HTTP server template:

```bash
git clone https://github.com/PerfectlySoft/PerfectTemplate.git
```

In this case, please modify the Package.swift and manually adding Perfect-libxml2 / Perfect-XML libraries like this:

```Swift
import PackageDescription

let package = Package(
	name: "PerfectXMLServer",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-libxml2.git", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-XML.git", majorVersion: 2, minor: 0)
    ]
)
```

Please also include PerfectXML library in your swift code:

```Swift
import PerfectXML
```

Then you can use Swift Package Manager to build it up:

```bash
swift build
```

Once done, you can run this server at local port 8181:

```bash
./.build/debug/PerfectXMLServer
```

use browser or the following curl command can see a "Hello, world!" message:
```bash
curl -I http://localhost:8181/
```

## A Sample XML content

Before doing any actual accessing operation, please copy the following XML sample string to your server, or you can make a similar file stored on your server and read it out into the same string:

```Swift
let rssXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" +
"<rss version=\"2.0\">" +
"<channel>" +
"<title attribute1='first attribute' attribute2='second attribute'>W3Schools Home Page</title>" +
"<link>http://www.w3schools.com</link>" +
"<description>Free web building tutorials</description>" +
"<item id='rssID'>" +
"<title>RSS Tutorial</title>" +
"<link>http://www.w3schools.com/xml/xml_rss.asp</link>" +
"<description>New RSS tutorial on W3Schools</description>" +
"</item>" +
"<item id='xmlID'>" +
"<title>XML Tutorial</title>" +
"<link>http://www.w3schools.com/xml</link>" +
"<description>New XML tutorial on W3Schools</description>" +
"<deeper xmlns:foo='foo:bar'>" +
"<deepest foo:atr1='the value' foo:atr2='the other value'></deepest>" +
"<foo:fool><foo:silly>boo</foo:silly><foo:dummy>woo</foo:dummy></foo:fool>" +
"</deeper>" +
"</item>" +
"</channel>" +
"</rss>"
```

## Make it pretty

Yes, I know your first impression about this above XML - ugly, right? But the good news is that now we can turn it into a pretty format:

```Swift
let xDoc = XDocument(fromSource: rssXML)
let prettyString = xDoc?.string(pretty: true)
let plainString = xDoc?.string(pretty: false)
```

The first line ``` xDoc = XDocument ``` created an XML object, and the method ```string(pretty: Bool)``` can get the text content back with an option of pretty format or not.

You must want to know how pretty it is, right? OK, paste the following snippet and check it out:

```Swift
routes.add(method: .get, uri: "/parse", handler: {
		request, response in

    // title of the page
		let title = "XML Parse Function"

		response.setHeader(.contentType, value: "text/html")

    // setup CSS to make the table layout a better looking
		response.appendBody(string: "<html><head><title>\(title)</title><style>td{word-wrap: break-word;}table{table-layout: fixed; width: 100%}</style></head><body>\n")

    // table head
		response.appendBody(string: "<H1>\(title)</H1><table border=1><tr>" +
			"<th width='30%'>Original</th>" +
			"<th width='30%'>Parsed String with pretty printing</th>"
			+ "<th width='30%'>Parsed String without pretty printing</th></tr>\n")

    // compare three outputs
		response.appendBody(string: "<tr><td><xmp>\(rssXML)</xmp></td><td><xmp>\(prettyString!)</xmp></td><td><xmp>\(plainString!)</xmp></td></tr>\n")

    //
		response.appendBody(string: "</table></body></html>\n")
		response.completed()
	}
)
```

If success, you can check ```http://localhost:8181/parse``` and then should see a web page by checking an API of  with a table of three columns. The left one is the original XML, the right one is a parsed string and the middle one is the formatted string after parsing.  

## Working with Nodes

XML is a structured documentation standard with a basic format of <A>B</A> - an XML node. Each node has a tag name, a value, or sub nodes we call "children". To better understand these definitions, trying the following code to "walk through" the whole XML is highly recommended.

Firstly, we will need a recursive function to iterate all elements inside:

```Swift
/// Print all child nodes into an HTTP response
func printChildrenName(_ response: HTTPResponse, _ xNode: XNode) {

  // try treating the current node as a text node
	guard let text = xNode as? XText else {

      // print out the node info
			response.appendBody(string: "<tr><td>\(xNode.nodeName)</td><td>\(xNode.nodeType)</td><td>(children)</td></tr>\n")

      // find out children of the node
			for n in xNode.childNodes {

        // call the function recursively and take the same produces
				printChildrenName(response, n)
			}
			return
	}

  // it is a text node and print it out
	response.appendBody(string: "<tr><td>\(xNode.nodeName)</td><td>\(xNode.nodeType)</td><td><xmp>\(text.nodeValue!)</xmp></td></tr>\n")

}
```


Now we can add a route to show the whole structure of this XML file:

```Swift
routes.add(method: .get, uri: "/nodes", handler: {
		request, response in

		let title = "Node Name, Type and Value"
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>\(title)</title><body>\n")
		response.appendBody(string: "<H1>\(title)</H1><H2>Original RSS XML</H2><p><xmp>\(prettyString!)</xmp></p><H2>\(title)</H2>\n")

		response.appendBody(string: "<table border=1><tr><th>Name</th><th>Type</th><th>Value</th></tr>\n")
		printChildrenName(response, xDoc!)
		response.appendBody(string: "</table></body></html>")
		response.completed()
	}
)
```

Now you can check out ```http://localhost:8181/nodes``` to see the whole parsed structure.


## Access Node by Tag Name

A very basic way of querying a specific node is by the tag name. The snippet below shows the method of ```getElementsByTagName ``` in a general manner:

```Swift
routes.add(method: .get, uri: "/getElementsByTagName", handler: {
		request, response in

    // firstly parse a variable called 'tagName' from the URL GET method
		let tagName = request.param(name:"tagName", defaultValue:"channel")

    // previously we used "text/html" to display a webpage, this time we will use plain text instead
		response.setHeader(.contentType, value: "text/plain")

    // use .getElementsByTagName to get this node.
    // check if there is such a tag in the xml document
		guard let node = xDoc?.documentElement?.getElementsByTagName(tagName!) else {
			response.appendBody(string: "There is no such a tag: `\(tagName!)`")
			response.completed()
			return
		}

    // if is, get the first matched
		guard let serverMessage = node.first?.nodeValue else {
			response.appendBody(string: "Tag `\(tagName)` has no value")
			response.completed()
			return
		}

    // show the node value
		response.appendBody(string: serverMessage)
		response.completed()
	}
)
```

Once done, you can run curl commands to see different returns

```bash
curl http://localhost:8181/getElementsByTagName?tagName=link; echo
curl http://localhost:8181/getElementsByTagName?tagName=description; echo
```

## Access Node by ID

Alternatively, you may also notice that any node can have an attribute called "id", which means you can access this node without knowing its tag:

```XML
<item id='xmlID'>
```

To get this node by ID, PerfectXML provides a method called .getElementById(), so we can build another route to do the similar API as the previous example but this time we will try the id method:

```Swift
routes.add(method: .get, uri: "/getElementById", handler: {
		request, response in

		let id = request.param(name:"id", defaultValue:"xmlID")

		response.setHeader(.contentType, value: "text/plain")

    // Access node by its id, if available
		guard let node = xDoc?.getElementById(id!) else {
			response.appendBody(string: "There is no such a id: `\(id!)`")
			response.completed()
			return
		}

		guard let serverMessage = node.nodeValue else {
			response.appendBody(string: "id `\(id!)` has no value")
			response.completed()
			return
		}
		response.appendBody(string: serverMessage)
		response.completed()
	}
)
```

Again, use curl commands to test this new API route:

```bash
curl http://localhost:8181/getElementById?id=rssID; echo
curl http://localhost:8181/getElementById?id=xmlID; echo
```

Anyway can you see the difference of .getElementById() and .getElementsByTagName() ? You can have a try to see if there are duplicated IDs in the same XML.

## More about getElementsByTagName()

Method .getElementsByTagName returns an array of nodes, i.e., [XElement], just like a record set in a database query.

The following code demonstrates how to iterate all element in this arrray:

```Swift
routes.add(method: .get, uri: "/items", handler: {
		request, response in

    // get all items with tag name of "item"
		let feedItems = xDoc?.documentElement?.getElementsByTagName("item")

    // checkout how many items indeed.
		let itemsCount = feedItems?.count

    // show a web page about these items
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>Items</title><body>\n")
		response.appendBody(string: "<H1>There are totally \(itemsCount!) Items Found</H1>\n")
		response.appendBody(string: "<H2>Original RSS XML</H2><p><xmp>\(prettyString!)</xmp></p>\n")

    // make a table layout to display all items in a better looking
		response.appendBody(string: "<H2>Items</H2><p><table border=1><tr><th>Title</th><th>description</th></tr>\n")

    // iterate all items in the result set
		for item in feedItems!
		{
        // display all properties (text nodes) of an item
				let title = item.getElementsByTagName("title").first?.nodeValue
				let link = item.getElementsByTagName("link").first?.nodeValue
				let description = item.getElementsByTagName("description").first?.nodeValue
				response.appendBody(string: "<tr><td>\(title!)</td><td><a href='\(link!)'>\(description!)</a></td></tr>\n")
		}

    // end of the page
		response.appendBody(string: "</table></p></body></html>")
		response.completed()
	}
)
```

Use a web browser to check ```http://localhost:8181/items``` to see the page.

## Relationships of a Node Family

PerfectXML provides a convenient way to access all relationships of a specific XML node: Parent, Siblings & Children.

### Parent of a Node

Parent node can be accessed by a node property called "parentNode", see the following example to see the usage:

```Swift
routes.add(method: .get, uri: "/parent", handler: {
		request, response in

		let tag = request.param(name:"tagName", defaultValue:"link")
		guard let node = xDoc?.documentElement?.getElementsByTagName(tag!).first else {
			response.appendBody(string: "There is no such a tag '\(tag!)'.\n")
			response.completed()
			return
		}

    // HERE is the way of accessing a parent node
		guard let parent = node.parentNode else {
			response.appendBody(string: "Tag '\(tag!)' is the root node.\n")
			response.completed()
			return
		}
		var name = parent.nodeName
		response.appendBody(string: "Parent of '\(tag!)' is '\(name)'\n")
		response.completed()
	}
)
```

After building, run curl command to check if it is working, and please try any tag as need.

```bash
curl http://localhost:8181/parent?tagName=link
```

### Node Siblings

Each XML node can have two siblings: previousSibling and nextSibling. Try the following snippet to test the availability of siblings.

```Swift
routes.add(method: .get, uri: "/siblings", handler: {
		request, response in

    let title = "Siblings of a Node"
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>\(title)</title><body>\n")
		response.appendBody(string: "<H1>\(title)</H1><H2>Original RSS XML</H2><p><xmp>\(prettyString!)</xmp></p>\n")

		let node = xDoc?.documentElement?.getElementsByTagName("link").first

    // Check the previous sibling of current node
		let previousNode = node?.previousSibling

		var name = previousNode?.nodeName
		var value = previousNode?.nodeValue
		response.appendBody(string: "<H2>Previous Sibling of Link</H2><p> is</p><p>\(name!):&nbsp\(value!)</p>\n")


    // Check the next sibling of current node
    let nextNode = node?.nextSibling
		name = nextNode?.nodeName
		value = nextNode?.nodeValue
		response.appendBody(string: "<H2>Next Sibling of Link</H2><p> is</p><p>\(name!):&nbsp\(value!)</p>\n")

		response.appendBody(string: "</body></html>")
		response.completed()
	}
)
```

The uri of the above snippet is /siblings, so you can try ```http://localhost:8181/siblings``` in a web browser to see what happened.

### First & Last Child

If an XML node has a child, then you can try properties of .firstChild / .lastChild instead of accessing them from the .childNodes array:

```Swift
routes.add(method: .get, uri: "/firstlast", handler: {
		request, response in

		let title = "First & Last Child"
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>\(title)</title><body>\n")
		response.appendBody(string: "<H1>\(title)</H1><H2>Original RSS XML</H2><p><xmp>\(prettyString!)</xmp></p>\n")

		let node = xDoc?.documentElement?.getElementsByTagName("channel").first

    /// retrieve the first child
		let firstChild = node?.firstChild
		var name = firstChild?.nodeName
		var value = firstChild?.nodeValue
		response.appendBody(string: "<H2>First Child of Channel</H2><p> is</p><p>\(name!):&nbsp\(value!)</p>\n")

    /// retrieve the last child
		let lastChild = node?.lastChild
		name = lastChild?.nodeName
		value = lastChild?.nodeValue
		response.appendBody(string: "<H2>Last Child of Channel</H2><p> is</p><p>\(name!):&nbsp\(value!)</p>\n")


		response.appendBody(string: "</body></html>")
		response.completed()
	}
)
```

These methods are convenient in certain scenarios, such as jump to the first page or the last page in a book.

## Node Attributes

Any XML node / element can have attributes in such a style:

 ```XML
 <node attribute1='value of attribute1' attribute2='value of attribute2'>
   ...
 </node>
```

Node method .getAttribute(name: String) provides the functionality of accessing attributes. See the code below:

```Swift
routes.add(method: .get, uri: "/attributes", handler: {
		request, response in

		let title = "Attributes of an element"
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>\(title)</title><body>\n")
		response.appendBody(string: "<H1>\(title)</H1><H2>Original RSS XML</H2><p><xmp>\(prettyString!)</xmp></p>\n")

		let node = xDoc?.documentElement?.getElementsByTagName("title").first

    /// get some attributes of a node
		let att1 = node?.getAttribute(name: "attribute1")
		response.appendBody(string: "<H2>attribute1 of title</H2><p> is</p><p>\(att1)</p>\n")

		let att2 = node?.getAttributeNode(name: "attribute2")
		response.appendBody(string: "<H2>attribute2 of title</H2><p> is</p><p>\(att2?.value)</p>\n")
		response.appendBody(string: "</body></html>")
		response.completed()
	}
)
```

## Namespaces

XML namespaces are used for providing uniquely named elements and attributes in an XML document. An XML instance may contain element or attribute names from more than one XML vocabulary. If each vocabulary is given a namespace, the ambiguity between identically named elements or attributes can be resolved.

Both .getElementsByTagName() and .getAttributeNode() have namespace versions, i.e., .getElementsByTagNameNS() / .getAttributeNodeNS, etc. In these cases, namespaceURI and localName shall present to complete the request.

The following code demonstrates the usage of .getElementsByTagNameNS() and .getNamedItemNS():

```Swift
routes.add(method: .get, uri: "/namespaces", handler: {
		request, response in

		let title = "Namespaces"
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>\(title)</title><body>\n")
		response.appendBody(string: "<H1>\(title)</H1><H2>Original RSS XML</H2><p><xmp>\(prettyString!)</xmp></p>\n")

		let deeper = xDoc?.documentElement?.getElementsByTagName("deeper").first
		let atts = deeper?.firstChild?.attributes;
		let item = atts?.getNamedItemNS(namespaceURI: "foo:bar", localName: "atr2")
		response.appendBody(string: "<H2>Namespace of deeper has an attribute of</H2><p>\(item?.nodeValue)</p>\n")

		let foos = xDoc?.documentElement?.getElementsByTagNameNS(namespaceURI: "foo:bar", localName: "fool")
		var count = foos?.count
		let node = foos?.first
		let name = node?.nodeName
		let localName = node?.localName
		let prefix = node?.prefix
		let nuri = node?.namespaceURI

		response.appendBody(string: "<H2>Namespace of 'foo:bar' has \(count!) element</H2>" +
		"<p>Node Name: \(name!)</p>\n" +
		"<p>Local Name: \(localName!)</p>\n" +
		"<p>Prefix: \(prefix!)</p>\n" +
		"<p>Namespace URI: \(nuri!)</p>\n"
		)

		let children = node?.childNodes

		count = children?.count

		let a = node?.firstChild
		let b = node?.lastChild

		let na = a?.nodeName
		let nb = b?.nodeName
		let va = a?.nodeValue
		let vb = b?.nodeValue

		response.appendBody(string: "<h3>This node also has \(count!) children.</h3>" +
		"<p>The first one is called '\(na!)' with value of '\(va!)',</p>" +
		"<p>And the last one is called '\(nb!)' with value of '\(vb!)'.</p>"
		)

		response.appendBody(string: "</body></html>")
		response.completed()
	}
)
```

You can try ```http://localhost:8181/namespaces``` in a web browser to see the namespaces demo page.

## XPath

Now you will see the most interesting part of this demo - XPath. XPath (XML Path Language) is a query language for selecting nodes from an XML document. In addition, XPath may be used to compute values (e.g., strings, numbers, or Boolean values) from the content of an XML document.

To show the unlimited power of XPath, hereby I introduce a very special snippet below. In this code, all HTTP requests other than the all previous examples will be wrapped up and routed into a single page called "XML Path Demo".

This demo can extract the random path from the HTTP request, and then map this request to the XML XPath:

```Swift
routes.add(method: .get, uri: "/**", handler: {
		request, response in

		let title = "XML Path Demo"
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>\(title)</title><body>\n")
		response.appendBody(string: "<H1>\(title)</H1><H2>Original RSS XML</H2><p><xmp>\(prettyString!)</xmp></p>\n")

    /// Use .extract() method to deal with the XPath request.
		let pathResource = xDoc?.extract(path: request.path)


		response.appendBody(string: "<H2>Your Request '\(request.path)' found:</H2><p>\(pathResource!)</p>\n")
		response.appendBody(string: "<H3>Examples</H3> ")
		response.appendBody(string: "<p><a href='/rss/channel/item'>/rss/channel/item</a></p> ")
		response.appendBody(string: "<p><a href='/rss/channel/title/@attribute1'>/rss/channel/title/@attribute1</a></p> ")
		response.appendBody(string: "<p><a href='/rss/channel/link/text()'>/rss/channel/link/text()</a></p> ")
		response.appendBody(string: "<p><a href='/rss/channel/item[2]/deeper/foo:bar'>/rss/channel/item[2]/deeper/foo:bar</a></p> ")
		response.appendBody(string: "<H3>Please try yourself in the URL as many different pathes as you want!!!</H3> ")

		response.completed()
	}
)
```

Then build & run this server and type any possible XPath into your browser to check the different outcomes. Now you can see how powerful XML & XPath are - theoretically, it can even wrap up a total file system, can't it?

Have Fun!


###Compatibility with Swift

This project works only with the Swift 3.0 toolchain available with Xcode 8.0+ or on Linux via [Swift.org](http://swift.org/).

## Swift version note:

Due to a late-breaking bug in Xcode 8, if you wish to run directly within Xcode, we recommend installing swiftenv and installing the Swift 3.0.1 preview toolchain.

```
# after installing swiftenv from https://swiftenv.fuller.li/en/latest/
swiftenv install https://swift.org/builds/swift-3.0.1-preview-1/xcode/swift-3.0.1-PREVIEW-1/swift-3.0.1-PREVIEW-1-osx.pkg
```

Alternatively, add to the "Library Search Paths" in "Project Settings" $(PROJECT_DIR), recursive.


## Issues

We are transitioning to using JIRA for all bugs and support related issues, therefore the GitHub issues has been disabled.

If you find a mistake, bug, or any other helpful suggestion you'd like to make on the docs please head over to [http://jira.perfect.org:8080/servicedesk/customer/portal/1](http://jira.perfect.org:8080/servicedesk/customer/portal/1) and raise it.

A comprehensive list of open issues can be found at [http://jira.perfect.org:8080/projects/ISS/issues](http://jira.perfect.org:8080/projects/ISS/issues)



## Further Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
