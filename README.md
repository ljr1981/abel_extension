See the Wiki for this project for the support link or direct access at:

https://docs.google.com/forms/d/1P0ZswpsoGdmmJsQhvRBw6SXaUM6iDRbq44HUQA2J2I4/viewform

ABEL Extension
==============

An extension library to the Eiffel ABEL library.

Title
==============

ABEL Extension Library

Description
==============

Extensions to the functionality of the ABEL library.

Purpose
==============

To extend and enhance the facilities of the ABEL library, specifically
adding general features found in most databases (e.g. min, max, count, etc).

How
==============

By adding a series of extension, helper, and constants classes designed
to meet the purpose statement above.

Prerequisites
==============

Items to study before continuing

	The ABEL ("A Better Eiffelstore Library") library and its Tutorial
	documentation as well as the "back-end" documentation.

Basics
==============

Library and cluster only basics of design

The ABEL extension library is mostly about two ideas: Making generic,
easy, and reusable complex queries, hiding the complexity. Second, it
is about making various helper classes such as DATA_IDENTIFIED.

	* AE_DATA_ACCESSOR and AE_OBJECT_DATA_ACCESSOR [G]. Both of these classes allow
		for query access to a database, where DATA_ACCESSOR is generic
		to any object type stored in the database and AE_OBJECT_DATA_ACCESSOR [G]
		is about a specific object type (e.g. the G generic parameter).
	* AE_DATA_IDENTIFIED is the heart of adding facilities like "primary_key" to
		objects being stored in the database. Currently, ABEL offers no
		way to access the primary keys and other common database facilities.
		I believe this is due to the cross-database nature of the library
		where the target repositories may or may not have the same
		features available in them. AE_DATA_IDENTIFIED attempts to bring
		these common facilities like "primary_key" to every database.


Usage
==============

Optional statement of designer intended use


Cautions
==============

Things to watch out for

	
Generics
==============

Any clarification needed for generic parameters

	The OBJ moniker used generally represents the object(s) being persisted to
	the target database. This is true library-wide.

Compilation
==============

Optional compilation requirements
	

Dependencies
==============

Optional list of dependencies internal or external

	This library depends on the ABEL library. You will want to ensure the ECF
	pathing is properly set before this library will compile on your host machine.
	If this library should ever arrive in the IRON system, this need may be met
	automatically, relieving you of having to handle it yourself.

History
==============

	August 2014: While looking for a simpler database management library in
		Eiffel, I was reminded of the ABEL project and decided to investigate.
		I was pleasantly surprised to find a relatively well-crafted and
		usable (reusable) library in ABEL. Secondarily, and more
		importantly, I tool strong note of the very nice documentation
		provided with the library. It facilitated my understanding of how
		to successfully use the library rather quickly. Over time, I have
		discovered missing orientation material (highly expected) and have
		made a note to provide that material by way of instructional videos.
		This library is an outgrowth of that effort. I started with no
		aspiration to produce and maintain and extension library. Moreover,
		I fully expect that where it makes sense, features of this library
		will be abstracted back into ABEL itself, nullifying the need for
		this extension (hence the name). Finally, I invite you to add your
		own extensions to this code as you see fit. It is completely open-source
		for that reason, under the GPL license agreement.

Glossary
==============

	primary_key: In database relational modeling and implementation, a unique key is 
		the attribute or a set of concatenated attributes in an entity whose 
		value(s) guarantee only one tuple (row) exists for each unique value. 
		The primary key has to consist of attributes that cannot be collectively 
		duplicated by any other row.

Examples
==============

	See test code (more coming) for example usage.	

Clusters
==============

	See NOTES.txt

See also
==============

	https://docs.google.com/forms/d/1P0ZswpsoGdmmJsQhvRBw6SXaUM6iDRbq44HUQA2J2I4/viewform

Renames
==============

	See NOTES.txt

Bugs
==============

	See NOTES.txt

Todos
==============

	See NOTES.txt

Refactors
==============

	See NOTES.txt

Fixmes
==============

	See NOTES.txt
