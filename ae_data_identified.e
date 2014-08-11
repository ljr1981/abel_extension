note
	title: "[
		ABEL Extension Data Identified
		]"
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
	AE_DATA_IDENTIFIED

feature -- Access

	primary_key_name: STRING = "primary_key"
	primary_key: INTEGER_64
			-- Primary Key of Current.

	is_deleted: BOOLEAN
			-- Is Current marked as deleted?

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
			not_is_deleted: not is_deleted
		do
			set_primary_key ((create {AE_DATA_ACCESSOR}).maximum_primary_key (a_database, tuple_query_anchor) + primary_key_increment_step_value)
		ensure
			primary_key_set: primary_key >= some_primary_key
			not_is_deleted: not is_deleted
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
			not_is_deleted: not is_deleted
		do
			primary_key := a_primary_key
		ensure
			primary_key_set: primary_key ~ a_primary_key
			not_is_deleted: not is_deleted
		end

feature -- Basic Operations

	delete
			-- Set `is_deleted' to True.
		do
			is_deleted := True
		ensure
			is_deleted: is_deleted
		end

	recall
			-- Set `is_deleted' to False.
		do
			is_deleted := False
		ensure
			not_is_deleted: not is_deleted
		end

feature {NONE} -- Implementation: Anchors

	tuple_query_anchor: PS_TUPLE_QUERY [AE_DATA_IDENTIFIED]
			-- TUPLE query anchor for Current.
		note
			purpose: "[
				To provide a type anchor for descendents of Current.
				]"
			how: "[
				In the direct descendent declaration, change the generic
				from [ANY] to "[like Current]", which will force the type
				conformance of the anchor to change from ANY of Current
				to the generic parameter type declared in the descendent. 
				
				Also, add a "do create Result.make end", which will handle
				creation on-demand. See example below.
				]"
			example: "[
				tuple_query_anchor: PS_TUPLE_QUERY [like Current]
						-- <Precursor>
					do
						create Result.make
					end
				]"
			caution: "[
				If you attempt to make this feature attached, but created by
				the creation procedure of the descendent class (e.g. you
				make the descendent responsible for creation of this feature
				instead of making it either detachable and creating it at the
				point-of-use -OR- doing as the "example" above), then when
				you attempt to persist using "transaction.insert (object)",
				ABEL will set up an endless loop, trying to create instances
				and persist each one to the database. 
				
				This feature is NOT intended to persist to the database. Thus, 
				ensure that it is either detachable or a query-routine, so ABEL 
				will ignore it in the internal reflection used to identify 
				persistable features.
				]"
		deferred
		end

end
