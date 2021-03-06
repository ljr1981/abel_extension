note
	description: "[
		A testing object for testing how objects interact with Abel Extension classes.
		]"
	purpose: "[
		To provide ABEL Extension testing something to persist to a test in-memory database.
		]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_OBJECT_ONE

inherit
	AE_DATA_IDENTIFIED

feature -- Access

	some_number: INTEGER
			-- A single integer feature for testing

feature -- Settings

	set_some_number (a_number: like some_number)
			-- Sets `some_number' with `a_number'.
		do
			some_number := a_number
		ensure
			some_number_set: some_number = a_number
		end

feature {NONE} -- Implementation

	tuple_query_anchor: PS_TUPLE_QUERY [like Current]
			-- <Precursor>
		do
			create Result.make
		end

end
