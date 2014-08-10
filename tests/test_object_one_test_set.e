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

	test_database_functions_of_data_accessor
			-- See purpose statement
		note
			purpose: "[
				To test AE_DATA_ACCESSOR functions and AE_DATA_IDENTIFIED as its client.
				]"
			how: "[
				By creating several TEST_OBJECT_ONE items, placing them in the database and then
				exerciding the database functions in the accessor either directly or through the
				exercising of the AE_DATA_IDENTIFIED facilities. Specifically, we're looking to
				test the maximum primary key, minimum primary key, count, and average features.
				]"
		local
			l_transaction: PS_TRANSACTION
			l_object: TEST_OBJECT_ONE
			l_average_data: like {AE_DATA_ACCESSOR}.average
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
				-- Test remaining functions (MIN, COUNT, AVG)
			assert_equals ("has_min_id_of_1", (1).to_integer_64, (create {AE_DATA_ACCESSOR}).minimum_primary_key (test_database, create {PS_TUPLE_QUERY [TEST_OBJECT_ONE]}.make))
			assert_equals ("has_count_of_2", (2).to_integer_32, (create {AE_DATA_ACCESSOR}).count (test_database, create {PS_TUPLE_QUERY [TEST_OBJECT_ONE]}.make))
				-- Get the average data and test it
			l_average_data := (create {AE_DATA_ACCESSOR}).average (test_database, create {PS_TUPLE_QUERY [TEST_OBJECT_ONE]}.make, "primary_key")
			assert_equals ("has_avg_of_1_1_/_2", (1.5).truncated_to_real, l_average_data.t_average)
			assert_equals ("has_avg_total_of_3", (3.0).truncated_to_real, l_average_data.t_total)
			assert_equals ("has_avg_cnt_of_2", (2.0).truncated_to_real, l_average_data.t_count)
		end

feature {NONE} -- Implementation: Database

	test_database: PS_REPOSITORY
			-- Primary product database.

end


