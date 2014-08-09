note
	title: "[
		ABEL Extension Data Accessor
		]"
	description: "[
		An ABEL Extension factory for accessing data using predefined queries
		that are more sophisticated than the queries available in PS_QUERY.
		]"
	author: "[
		Larry Rix
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	AE_DATA_ACCESSOR [OBJ -> ANY]

create
	make_with_repository

feature {NONE} -- Initialization

	make_with_repository (a_repository: like internal_repository)
			-- Initialize Current with `a_repository'.
		do
			internal_repository := a_repository
		ensure
			repository_set: internal_repository ~ a_repository
		end

feature -- Status Report

	all_objects: ARRAYED_LIST [OBJ]
			-- A list of `all_products'.
		local
			l_query: PS_QUERY [OBJ]
		do
			create l_query.make
			internal_repository.execute_query (l_query)
			create Result.make (100)
			across l_query as ic_results loop
				Result.force (ic_results.item)
			end
			l_query.close
		end

	exactly_like (a_feature_name: STRING; a_value: ANY): ARRAYED_LIST [OBJ]
			-- OBJ in `internal_repository' with `a_feature_name' exactly like `a_value'.
		local
			l_query: PS_QUERY [OBJ]
		do
			create Result.make (100)
			create l_query.make_with_criterion ((create {PS_CRITERION_FACTORY}).new_predefined (a_feature_name, {PS_CRITERION_FACTORY}.equals, a_value))
			internal_repository.execute_query (l_query)
			across l_query as ic_products loop Result.force (ic_products.item) end
			l_query.close
		end

	something_like (a_feature_name: STRING; a_value: STRING): ARRAYED_LIST [OBJ]
			-- OBJ in `internal_repository' with `a_feature_name' something like `a_value'.
		local
			l_query: PS_QUERY [OBJ]
		do
			create Result.make (100)
			create l_query.make_with_criterion ((create {PS_CRITERION_FACTORY}).new_predefined (a_feature_name, {PS_CRITERION_FACTORY}.like_string, a_value))
			internal_repository.execute_query (l_query)
			across l_query as ic_products loop Result.force (ic_products.item) end
			l_query.close
		end

	starts_with (a_feature_name: STRING; a_value: STRING): like something_like
			-- Product in `internal_repository' with a matching number that starts with `a_value'.
		local
			l_value: STRING
		do
			l_value := a_value.twin
			if not l_value.has_code (('*').code.to_natural_32) then
				l_value.append_character ('*')
			end
			Result := something_like (a_feature_name, l_value)
		end

	ends_with (a_feature_name: STRING; a_value: STRING): like something_like
			-- Product in `internal_repository' with a matching number that ends with `a_value'.
		local
			l_value: STRING
		do
			l_value := a_value.twin
			if not l_value.has_code (('*').code.to_natural_32) then
				l_value.prepend_character ('*')
			end
			Result := something_like (a_feature_name, l_value)
		end

	contains (a_feature_name: STRING; a_value: STRING): like something_like
			-- Product in `internal_repository' with a matching number that contains `a_value'.
		local
			l_value: STRING
		do
			l_value := a_value.twin
			if not l_value.has_code (('*').code.to_natural_32) then
				l_value.prepend_character ('*')
				l_value.append_character ('*')
			end
			Result := something_like (a_feature_name, l_value)
		end

	maximum_data_id: INTEGER_64
			-- What is the maximum `data_id' of Current {G}?
		do
			if attached {INTEGER_64} maximum ("data_id") as al_result then
				Result := al_result
			else
				Result := 0
			end
		end

	maximum (a_field_name: STRING): detachable COMPARABLE
			-- Maximum value of `a_field'.
		local
			l_query: PS_TUPLE_QUERY [OBJ]
			l_projection: ARRAYED_LIST [STRING]
		do
			create l_query.make
			create l_projection.make_from_array (<<a_field_name>>)
			l_query.set_projection (l_projection)
			internal_repository.execute_tuple_query (l_query)
			across l_query as ic_results loop
				if attached {COMPARABLE} ic_results.item as al_result then
					if attached Result as al_attached_result and then al_result > al_attached_result then
						Result := al_result
					end
				end
			end
			l_query.close
		end

feature -- Access

	repository: like internal_repository
		do
			Result := internal_repository
		end

feature {NONE} -- Implementation

	internal_repository: PS_REPOSITORY
			-- Interal reference for repository of Current.

end
