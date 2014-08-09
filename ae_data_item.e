note
	description: "[
		Abstract notion of an item (object) stored in a repository.
		]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AE_DATA_ITEM

feature -- Access

	data_id: INTEGER_64
			-- Primary key (i.e. unique identifier value) of Current.

feature -- Settings

	set_data_id (a_data_id: like data_id)
			-- Set `data_id' with `a_data_id'
		do
			data_id := a_data_id
		ensure
			data_id_set: data_id = a_data_id
		end

end
