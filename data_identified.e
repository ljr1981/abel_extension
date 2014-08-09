note
	description: "[
		Abstraction of an object identified in a database.
		]"
	purpose: "[
		To facilitate storage of some object in a database for later
		easy retrieval and reference.
		]"
	how: "[
		The `primary_key' value is designed as a unique identifier for Current
		while it is stored in a database. The `primary_key_name' will not be
		stored in the database due to it being a constant.
		]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DATA_IDENTIFIED

feature -- Access

	primary_key_name: STRING = "primary_key"
	primary_key: INTEGER_64
			-- Primary Key of Current.

feature -- Access: Constants

	no_primary_key: INTEGER_64 = 0
	some_primary_key,
	primary_key_increment_step_value: INTEGER_64 = 1
		-- Absence of a primary key is zero or less
		-- Primary keys are 1 or greater
		-- Primary keys are auto-incremented by a value of 1

feature -- Basic Operations

	set_primary_key_from_database (a_database: PS_REPOSITORY)
			-- Sets the `primary_key' from whatever the current max database value.
		note
			purpose: "[
				To set the primary key based on the maximum value of other objects
				like Current, plus one.
				]"
			how: "[
				Fetches the maximum primary key value from the database for other objects
				like Current, adds one to that value, and then sets `primary_key'.
				]"
		require
			no_primary_key: primary_key <= no_primary_key
		do
			set_primary_key ((create {DATA_ACCESSOR}).maximum_primary_key (a_database, tuple_query_anchor) + primary_key_increment_step_value)
		ensure
			primary_key_set: primary_key >= some_primary_key
		end

feature -- Settings

	set_primary_key (a_primary_key: like primary_key)
			-- Set `primary_key' with `a_primary_key'.
		note
			purpose: "[
				To set the primary key, but ONLY when it has not been previously set.
				]"
		require
			no_primary_key: primary_key <= no_primary_key
		do
			primary_key := a_primary_key
		ensure
			primary_key_set: primary_key ~ a_primary_key
		end

feature {NONE} -- Implementation: Anchors

	tuple_query_anchor: PS_TUPLE_QUERY [DATA_IDENTIFIED]
			-- TUPLE query anchor for Current.
		note
			purpose: "[
				To provide a type anchor for descendents of Current.
				]"
			how: "[
				In the direct descendent declaration, change the generic
				from ANY to "like Current", which will force the type
				conformance of the anchor to change from ANY to whatever
				the type is of the descendent (otherwise it would remain
				ANY if left at this level).
				]"
		deferred
		end

end
