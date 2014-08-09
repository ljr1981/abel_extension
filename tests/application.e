note
	description : "abel_extension application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_factory: AE_OBJECT_DATA_ACCESSOR [ANY]
			l_accessor: AE_DATA_ACCESSOR
			l_id: AE_DATA_IDENTIFIED
			l_query: AE_DATA_QUERY_LIBRARY [ANY]
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end
