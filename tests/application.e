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
			l_factory: AE_DATA_ACCESSOR [ANY]
			l_item: AE_DATA_ITEM
			l_accessor: DATA_ACCESSOR
			l_id: DATA_IDENTIFIED
			l_query: DATA_QUERY_LIBRARY [ANY]
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end
