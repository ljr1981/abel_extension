note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_OBJECT_ONE_TEST_SET

inherit
	TEST_SET_HELPER
		redefine
			on_prepare
		end

feature {NONE} -- Initialization

	on_prepare
			-- <Precursor>
		do
			Precursor
			create test_data_accessor.make_with_repository ((create {PS_IN_MEMORY_REPOSITORY_FACTORY}.make).new_repository)
		end

feature -- Test routines

	test_test_object_one
			-- See purpose statement
		note
			purpose: "[
				This is a simple test to show that a TEST_OBJECT_ONE can be created, inserted, and
				committed to an in-memory database.
				]"
		local
			l_transaction: PS_TRANSACTION
			l_object: TEST_OBJECT_ONE
		do
			l_transaction := test_database.new_transaction
			assert ("no_transaction_creation_error", not l_transaction.has_error)
			create l_object
			l_object.set_data_id (test_data_accessor.maximum_data_id + 1)
			l_transaction.insert (l_object)
			assert ("l_object_is_persistent", l_transaction.is_persistent (l_object))
			l_transaction.update (l_object)
			l_transaction.commit

			assert_equals ("has_data_id_max_1", 1, test_data_accessor.maximum_data_id)
		end

feature {NONE} -- Implementation: Database

	test_database: PS_REPOSITORY
			-- Primary product database.
		do
			Result := test_data_accessor.repository
		end

	test_data_accessor: AE_DATA_ACCESSOR [TEST_OBJECT_ONE]
			-- Primary query factory and product database

end


