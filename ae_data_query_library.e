note
	title: "[
		ABEL Extension Data Query Library
		]"
	description: "[
		A library of various forms of predefined queries on the basis of OBJs.
		]"
	purpose: "[
		To query for specific OBJ instances or lists of OBJs as results of queries of
		various forms.
		]"
	author: "[
		Larry Rix
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	AE_DATA_QUERY_LIBRARY [OBJ -> ANY]

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
		note
			purpose: "[
				Provides a list of all OBJ's in `internal_repository' with not filtering.
				]"
		local
			l_query: PS_QUERY [OBJ]
		do
			create l_query.make
			internal_repository.execute_query (l_query)
			create Result.make (100)
			across l_query as ic_results loop
				Result.force (ic_results.item)
			end
		end

	exactly_like (a_feature_name: STRING; a_value: STRING): ARRAYED_LIST [OBJ]
			-- To fetch objects from `internal_repository' where contents of `a_feature_name' are precisely like `a_value'.
		note
			purpose: "[
				To fetch objects from `internal_repository' where contents of `a_feature_name' are precisely like `a_value'.
				]"
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
		note
			purpose: "[
				To fetch objects in `internal_repository' that are something like `a_value'.
				]"
			how: "[
				The ABEL way of doing "contains" (see contains below).
				]"
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
			-- To locate objects in `internal_repository' starting with `a_value'.
		note
			purpose: "[
				To fetch objects in `internal_repository' starting with `a_value'.
				]"
			how: "[
				By examining `a_value' and ensuring it is prepended with an asterisk (*),
				which indicates wild-card searching on the left side of the value (e.g. "starts with").
				]"
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
			-- To locate objects in `internal_repository' ending with `a_value'.
		note
			purpose: "[
				To fetch objects in `internal_repository' ending with `a_value'.
				]"
			how: "[
				By examining `a_value' and ensuring it is appended with an asterisk (*),
				which indicates wild-card searching on the right side of the value (e.g. "ends with").
				]"
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
			-- To locate objects in `internal_respository' with content containing `a_value'.
		note
			purpose: "[
				To fetch objects in `internal_respository' with content containing `a_value'.
				]"
			how: "[
				By examining `a_value' and ensuring it is prepended and appended with an asterisk (*),
				which indicates wild-card searching on either side of the value (e.g. "contains").
				]"
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

feature {NONE} -- Implementation

	internal_repository: PS_REPOSITORY
			-- Interal reference for repository of Current.

end
