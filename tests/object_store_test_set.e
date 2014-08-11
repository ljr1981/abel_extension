note
	description: "[
		Basic tests of the AE_OBJECT_STORE class and objects.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	OBJECT_STORE_TEST_SET

inherit
	TEST_SET_HELPER
		redefine
			on_prepare
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			Precursor
			test_database := (create {PS_IN_MEMORY_REPOSITORY_FACTORY}.make).new_repository
		end

feature -- Test routines

	test_basic_object_store
			-- Test of AE_OBJECT_STORE
		local
			l_store: AE_OBJECT_STORE [TEST_OBJECT_ONE]
			l_transaction: PS_TRANSACTION
			l_obj_a,
			l_obj_b: TEST_OBJECT_ONE
			l_obj_c,
			l_obj_d: detachable TEST_OBJECT_ONE
		do
			l_transaction := test_database.new_transaction
				-- Get A in first
			create l_obj_a
			l_obj_a.set_primary_key_from_database (test_database)
			l_transaction.insert (l_obj_a)
			l_transaction.commit
				-- Get B in next
			l_transaction.prepare
			create l_obj_b
			l_obj_b.set_primary_key_from_database (test_database)
			l_transaction.insert (l_obj_b)
			l_transaction.commit

				-- Now, can we get them from the store?
			create l_store
			l_obj_c := l_store.object_for_id (test_database, 1)
			l_obj_d := l_store.object_for_id (test_database, 2)
			assert ("has_object_c", attached l_obj_c)
			assert ("has_object_d", attached l_obj_d)
				-- Now reverse the matter and lets test the attached version
			l_obj_b := l_store.attached_object_for_id (test_database, 1)
			l_obj_a := l_store.attached_object_for_id (test_database, 2)
				-- Finally, let's test for something not in the database, like object #3 (we only have #1 and #2).
			l_obj_c := l_store.object_for_id (test_database, 3)
			assert ("no_object_for_id_3", not attached l_obj_c)
		end

	test_object_store_with_object_store_objects
			-- Test of the AE_OBJECT_STORE with test objects for that purpose.
		local
			l_store_object: TEST_STORE_OBJECT_ONE
			l_object: TEST_OBJECT_ONE
			l_transaction: PS_TRANSACTION
		do
			l_transaction := test_database.new_transaction
			create l_object
			create l_store_object
			l_store_object.set_primary_key_from_database (test_database)
			l_store_object.set_my_child (l_transaction, l_object)
			l_transaction.prepare
			l_transaction.insert (l_store_object)
			l_transaction.commit
				-- We now have a store object with a test object in the database
				-- Time to test for various keys and so on.
		end

feature {NONE} -- Implementation: Database

	test_database: PS_REPOSITORY
			-- Primary product database.

end


