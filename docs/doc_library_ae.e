note
	title: "[
		ABEL Extension Library Documentation
		]"
	description: "[
		Extensions to the functionality of the ABEL library.
		]"
	purpose: "[
		To extend and enhance the facilities of the ABEL library, specifically
		adding general features found in most databases (e.g. min, max, count, etc).
		]"
	how: "[
		By adding a series of extension, helper, and constants classes designed
		to meet the purpose statement above.
		]"
	prerequisites: "[
		The ABEL ("A Better Eiffelstore Library") library and its Tutorial
		documentation as well as the "back-end" documentation.
		]"
	basics: "[
		The ABEL extension library is mostly about two ideas: Making generic,
		easy, and reusable complex queries, hiding the complexity. Second, it
		is about making various helper classes such as AE_DATA_IDENTIFIED.
		]"
	usage: "[
		<optional_statement_of_designer_intended_use>
		]"
	cautions: "[
		<things_to_watch_out_for>
		]"
	generics: "[
		The OBJ moniker used generally represents the object(s) being persisted to
		the target database. This is true library-wide.
		]"
	compilation: "[
		<optional_compilation_requirements>
		]"
	dependencies: "[
		This library depends on the ABEL library. You will want to ensure the ECF
		pathing is properly set before this library will compile on your host machine.
		If this library should ever arrive in the IRON system, this need may be met
		automatically, relieving you of having to handle it yourself.
		]"
	history: "[
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
		]"
	glossary: "A list of term definitions"
	term: "[
		Primary Key: In database relational modeling and implementation, a unique key is
			the attribute or a set of concatenated attributes in an entity whose
			value(s) guarantee only one tuple (row) exists for each unique value.
			The primary key has to consist of attributes that cannot be collectively
			duplicated by any other row.
		]"
	examples: "[
		See test code (more coming) for example usage.
		]"
	clusters: "[
		<folder_names_and_brief_descriptions>
		2014 August: None
		]"
	see_also: "[
		2014 August: None
		]"
	renames: "[
		2014 August: None
		]"
	bugs: "[
		2014 August: Unaware of any at this time, but I know they are there.
		]"
	todos: "[
		2014 August: Add test code as examples for DATA_* classes, which were recently added.
		2014 August: Build-out the notion of AE_OBJECT_STORE, *_STORE_AWARE and other natural
			extensions of the process of object-graph management.
		]"
	refactors: "[
		2014 August: None
		]"
	fixmes: "[
		2014 August: None
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DOC_LIBRARY_AE

feature {NONE} -- Documentation

		data_accessor: detachable AE_DATA_ACCESSOR
			-- See `object_data_accessor' (next feature below).

		object_data_accessor: detachable AE_OBJECT_DATA_ACCESSOR [ANY]
			note
				description: "[
					Both of these classes allow
					for query access to a database, where AE_DATA_ACCESSOR is generic
					to any object type stored in the database and AE_OBJECT_DATA_ACCESSOR [G]
					is about a specific object type (e.g. the G generic parameter).
					]"
			attribute
				Result := Void
			end

		data_identified: detachable AE_DATA_IDENTIFIED
			note
				description: "[
					is the heart of adding facilities like "primary_key" to
					objects being stored in the database. Currently, ABEL offers no
					way to access the primary keys and other common database facilities.
					I believe this is due to the cross-database nature of the library
					where the target repositories may or may not have the same
					features available in them. AE_DATA_IDENTIFIED attempts to bring
					these common facilities like "primary_key" to every database.
					]"
			attribute
				Result := Void
			end

		object_store: detachable AE_OBJECT_STORE [AE_DATA_IDENTIFIED]
			note
				description: "[
					facilitates having `primary_key'-based references in objects
					rather than direct references (e.g. my_feature_id: INTEGER_64 + a
					my_feature: detachable MY_FEATURE
						do Result := (create AE_OBJECT_STORE [MY_FEATURE]).object_for_id (my_feature_id) end
					This means that each object can be loaded very quickly without
					having to load the entire object-graph. Facilitates loading the graph
					only as deep as is needed. However, it does not bar one from loading
					the deep object graph (e.g. all of it).
					]"
				examples: "[
					Use the local references below to see this class in operation.
					]"
			local
--				l_test: detachable OBJECT_STORE_TEST_SET
			attribute
				Result := Void
			end

end
