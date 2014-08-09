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
			test_database := (create {PS_IN_MEMORY_REPOSITORY_FACTORY}.make).new_repository
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
				-- Object one
			create l_object
			l_object.set_primary_key_from_database (test_database)

			l_transaction := test_database.new_transaction
			l_transaction.insert (l_object)
			l_transaction.commit

			assert_equals ("has_data_id_max_1", (1).to_integer_64, l_object.primary_key)

				-- Object two
			create l_object
			l_object.set_primary_key_from_database (test_database)

			l_transaction := test_database.new_transaction
			l_transaction.insert (l_object)
			l_transaction.commit

			assert_equals ("has_data_id_max_2", (2).to_integer_64, l_object.primary_key)
		end

feature {NONE} -- Implementation: Database

	test_database: PS_REPOSITORY
			-- Primary product database.

end


