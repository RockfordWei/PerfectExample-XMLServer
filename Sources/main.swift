//
//  main.swift
//  PerfectExample-XML
//
//  Created by Rockford Wei on 10/06/16.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectXML

// Create HTTP server.
let server = HTTPServer()

// Register your own routes and handlers
var routes = Routes()
routes.add(method: .get, uri: "/", handler: {
		request, response in
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
		response.completed()
	}
)


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

let xDoc = XDocument(fromSource: rssXML)
let prettyString = xDoc?.string(pretty: true)
let plainString = xDoc?.string(pretty: false)


// web browser: http://localhost:8181/parse
routes.add(method: .get, uri: "/parse", handler: {
		request, response in

		let title = "XML Parse Function"

		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><head><title>\(title)</title><style>td{word-wrap: break-word;}table{table-layout: fixed; width: 100%}</style></head><body>\n")
		response.appendBody(string: "<H1>\(title)</H1><table border=1><tr>" +
			"<th width='30%'>Original</th>" +
			"<th width='30%'>Parsed String with pretty printing</th>"
			+ "<th width='30%'>Parsed String without pretty printing</th></tr>\n")
		response.appendBody(string: "<tr><td><xmp>\(rssXML)</xmp></td><td><xmp>\(prettyString!)</xmp></td><td><xmp>\(plainString!)</xmp></td></tr>\n")
		response.appendBody(string: "</table></body></html>\n")
		response.completed()
	}
)


// web browser http://localhost:8181/nodes
func printChildrenName(_ response: HTTPResponse, _ xNode: XNode) {

	guard let text = xNode as? XText else {
			response.appendBody(string: "<tr><td>\(xNode.nodeName)</td><td>\(xNode.nodeType)</td><td>(children)</td></tr>\n")
			for n in xNode.childNodes {
				printChildrenName(response, n)
			}
			return
	}
	response.appendBody(string: "<tr><td>\(xNode.nodeName)</td><td>\(xNode.nodeType)</td><td><xmp>\(text.nodeValue!)</xmp></td></tr>\n")

}

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

// curl http://localhost:8181/getElementsByTagName?tagName=link
// curl http://localhost:8181/getElementsByTagName?tagName=description

routes.add(method: .get, uri: "/getElementsByTagName", handler: {
		request, response in

		let tagName = request.param(name:"tagName", defaultValue:"channel")

		response.setHeader(.contentType, value: "text/plain")

		guard let node = xDoc?.documentElement?.getElementsByTagName(tagName!) else {
			response.appendBody(string: "There is no such a tag: `\(tagName!)`")
			response.completed()
			return
		}

		guard let serverMessage = node.first?.nodeValue else {
			response.appendBody(string: "Tag `\(tagName)` has no value")
			response.completed()
			return
		}

		response.appendBody(string: serverMessage)
		response.completed()
	}
)

// curl http://localhost:8181/getElementById?id=rssID
// curl http://localhost:8181/getElementById?id=xmlID
routes.add(method: .get, uri: "/getElementById", handler: {
		request, response in

		let id = request.param(name:"id", defaultValue:"xmlID")

		response.setHeader(.contentType, value: "text/plain")

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

// web browser: http://localhost:8181/items
routes.add(method: .get, uri: "/items", handler: {
		request, response in

		let feedItems = xDoc?.documentElement?.getElementsByTagName("item")
		let itemsCount = feedItems?.count
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>Items</title><body>\n")
		response.appendBody(string: "<H1>There are totally \(itemsCount!) Items Found</H1>\n")
		response.appendBody(string: "<H2>Original RSS XML</H2><p><xmp>\(prettyString!)</xmp></p>\n")
		response.appendBody(string: "<H2>Items</H2><p><table border=1><tr><th>Title</th><th>description</th></tr>\n")
		for item in feedItems!
		{
				let title = item.getElementsByTagName("title").first?.nodeValue
				let link = item.getElementsByTagName("link").first?.nodeValue
				let description = item.getElementsByTagName("description").first?.nodeValue
				response.appendBody(string: "<tr><td>\(title!)</td><td><a href='\(link!)'>\(description!)</a></td></tr>\n")
		}
		response.appendBody(string: "</table></p></body></html>")
		response.completed()
	}
)

// curl http://localhost:8181/parent?tagName=link
routes.add(method: .get, uri: "/parent", handler: {
		request, response in

		let tag = request.param(name:"tagName", defaultValue:"link")
		guard let node = xDoc?.documentElement?.getElementsByTagName(tag!).first else {
			response.appendBody(string: "There is no such a tag '\(tag!)'.\n")
			response.completed()
			return
		}
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

// web browser http://localhost:8181/firstlast
routes.add(method: .get, uri: "/firstlast", handler: {
		request, response in

		let title = "First & Last Child"
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>\(title)</title><body>\n")
		response.appendBody(string: "<H1>\(title)</H1><H2>Original RSS XML</H2><p><xmp>\(prettyString!)</xmp></p>\n")

		let node = xDoc?.documentElement?.getElementsByTagName("channel").first
		let firstChild = node?.firstChild
		var name = firstChild?.nodeName
		var value = firstChild?.nodeValue
		response.appendBody(string: "<H2>First Child of Channel</H2><p> is</p><p>\(name!):&nbsp\(value!)</p>\n")

		let lastChild = node?.lastChild
		name = lastChild?.nodeName
		value = lastChild?.nodeValue
		response.appendBody(string: "<H2>Last Child of Channel</H2><p> is</p><p>\(name!):&nbsp\(value!)</p>\n")


		response.appendBody(string: "</body></html>")
		response.completed()
	}
)

// web browser http://localhost:8181/siblings
routes.add(method: .get, uri: "/siblings", handler: {
		request, response in

		let title = "Siblings of a Node"
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>\(title)</title><body>\n")
		response.appendBody(string: "<H1>\(title)</H1><H2>Original RSS XML</H2><p><xmp>\(prettyString!)</xmp></p>\n")

		let node = xDoc?.documentElement?.getElementsByTagName("link").first
		let previousNode = node?.previousSibling
		var name = previousNode?.nodeName
		var value = previousNode?.nodeValue
		response.appendBody(string: "<H2>Previous Sibling of Link</H2><p> is</p><p>\(name!):&nbsp\(value!)</p>\n")

		let nextNode = node?.nextSibling
		name = nextNode?.nodeName
		value = nextNode?.nodeValue
		response.appendBody(string: "<H2>Next Sibling of Link</H2><p> is</p><p>\(name!):&nbsp\(value!)</p>\n")

		response.appendBody(string: "</body></html>")
		response.completed()
	}
)

// web browser http://localhost:8181/attributes
routes.add(method: .get, uri: "/attributes", handler: {
		request, response in

		let title = "Attributes of an element"
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>\(title)</title><body>\n")
		response.appendBody(string: "<H1>\(title)</H1><H2>Original RSS XML</H2><p><xmp>\(prettyString!)</xmp></p>\n")

		let node = xDoc?.documentElement?.getElementsByTagName("title").first
		let att1 = node?.getAttribute(name: "attribute1")
		response.appendBody(string: "<H2>attribute1 of title</H2><p> is</p><p>\(att1)</p>\n")

		let att2 = node?.getAttributeNode(name: "attribute2")
		response.appendBody(string: "<H2>attribute2 of title</H2><p> is</p><p>\(att2?.value)</p>\n")
		response.appendBody(string: "</body></html>")
		response.completed()
	}
)

// web browser http://localhost:8181/namespaces
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
// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

// Set a document root.
// This is optional. If you do not want to serve static content then do not set this.
// Setting the document root will automatically add a static file handler for the route /**
// server.documentRoot = "./webroot"

// Gather command line options and further configure the server.
// Run the server with --help to see the list of supported arguments.
// Command line arguments will supplant any of the values set above.
configureServer(server)

do {
	// Launch the HTTP server.
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
