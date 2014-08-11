note
	description: "[
		Object for use in testing AE_OBJECT_STORE.
		]"
	usage: "[
		The intended use of this class is two-fold:
		
		1. Work out and prove the concepts of lazy-instantiation.
		2. From #1, design a class that encompasses these functions
			in such a way that adding features to a class it performed
			on the basis of adding said-class as the type of a
			a target feature on some class rather than creating
			this structure below by hand each time a new feature is
			wanted.
		]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_STORE_OBJECT_ONE

inherit
	AE_DATA_IDENTIFIED

feature -- Access

	my_child_id: INTEGER_64
			-- The primary key for `my_child'.

	my_child (a_database: PS_REPOSITORY): detachable TEST_OBJECT_ONE
			-- A test object to play with.
		do
			Result := (create {AE_OBJECT_STORE [TEST_OBJECT_ONE]}).object_for_id (a_database, my_child_id)
		end

feature -- Settings

	set_my_child (a_transaction: PS_TRANSACTION; a_child: attached like my_child)
			-- Set `a_child' into `my_child' using `a_transaction' based on some database.
		require
			prepared_transaction: a_transaction.active_queries.is_empty
		do
			a_child.set_primary_key_from_database (a_transaction.repository)
			a_transaction.insert (a_child)
			a_transaction.commit
			my_child_id := a_child.primary_key
		ensure
			child_set: attached my_child (a_transaction.repository) as al_my_child
							and then al_my_child.primary_key = my_child_id
		end

feature -- Implementation

	tuple_query_anchor: PS_TUPLE_QUERY [like Current]
			-- <Precursor>
		do
			create Result.make
		end

end
