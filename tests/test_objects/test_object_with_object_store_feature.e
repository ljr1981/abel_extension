note
	description: "[
		A Test Object which utilizes the AE_OBJECT_STORE_FEATURE
		]"
	purpose: "[
		To provide an example of an AE_OBJECT_STORE_FEATURE applied
		to the feature of a class (e.g. `test_object_one' feature
		below).
		]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_OBJECT_WITH_OBJECT_STORE_FEATURE

feature -- Access

	test_object_one: TEST_OBJECT_STORE_FEATURE
			-- Test object enclosed in an AE_OBJECT_STORE_FEATURE.
		note
			how: "[
				By having this reference, the actual "object" is
				held at the `test_object_one.item'
				]"
		attribute
			create Result
		end

end
