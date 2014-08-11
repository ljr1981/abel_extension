note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	OBJECT_STORE_FEATURE_TEST_SET

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

	test_object_store_feature
			-- Test of an Object Store Feature.
		local
			l_object: TEST_OBJECT_WITH_OBJECT_STORE_FEATURE
			l_one: TEST_OBJECT_ONE
		do
			create l_object
			create l_one

				-- Test to ensure item is not in the `test_database'.
			assert_equals ("no_item", Void, l_object.test_object_one.item)

				-- Set `l_one' into `l_object' ...
			l_object.test_object_one.set_item (test_database, l_one)

				-- Test to ensure `l_one' is in `l_object' in `test_database'.
			assert_equals ("object_one", l_one, l_object.test_object_one.existing_item)
			assert_equals ("pk_is_1", (1).to_integer_64, l_object.test_object_one.existing_item.primary_key)
		end

feature {NONE} -- Implementation: Database

	test_database: PS_REPOSITORY
			-- Primary product database.

end


