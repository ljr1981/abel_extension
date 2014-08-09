note
	description: "[
		ABEL Extension for accessing object-agnostic data in a database.
		]"
	purpose: "[
		To facilitate object-agnostic access to data contained in some PS_REPOSITORY.
		]"
	how: "[
		By using database and query references to take action on in
		ways that accomplish the goal of each feature, where the goal is
		either some answer to a question or a a group of objects resulting
		from the database access.
		]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	AE_DATA_ACCESSOR

feature -- Access

	maximum_primary_key (a_database: PS_REPOSITORY; a_tuple_query: PS_TUPLE_QUERY [AE_DATA_IDENTIFIED]): INTEGER_64
			-- Maximum `primary_key' value from some DATA_IDENTIFIED class.
		note
			purpose: "[
				To calculation the largest `primary_key' of the OBJ represented by the DATA_IDENTIFIED generic
				of `a_tuple_query' in `a_database'.
				]"
			how: "[
				By issuing a TUPLE-query against the database of OBJ (even an empty set) and (if results are
				found) iterating those results, looking for the largest value. Take special note of the
				"ic_cursor.item.item (1)". The first "item" is a TUPLE from the collection "ic_cursor". The
				second "item" is the first data element of the TUPLE. Finally, we use "first_tuple_item"
				instead of a "1" because the designer attempts to have no "magic-numbers" in his code.
				]"
			glossary: "[
				Magic-numbers: In computer programming, the term magic number has multiple meanings. It could refer to one or more 
					of the following:
					* A constant numerical or text value used to identify a file format or protocol; for files, see List of file 
						signatures
					* Distinctive unique values that are unlikely to be mistaken for other meanings (e.g., Globally Unique Identifiers)
					* Unique values with unexplained meaning or multiple occurrences which could (preferably) be replaced with 
						named constants
				]"
			EIS: "name=Magic_numbers", "protocol=URI", "src=http://en.wikipedia.org/wiki/Magic_number_(programming)", "tag=wikipedia"
		local
			l_projection: ARRAYED_LIST [STRING]
		do
			create l_projection.make_from_array (<<{AE_DATA_IDENTIFIED}.primary_key_name>>)
			a_tuple_query.set_projection (l_projection)
			a_database.execute_tuple_query (a_tuple_query)
			across a_tuple_query as ic_cursor loop
				if attached {INTEGER_64} ic_cursor.item.item (first_tuple_item) as al_item and then al_item > Result then
					Result := al_item
				end
			end
			a_tuple_query.close
		end

	first_tuple_item: INTEGER = 1

	minimum_primary_key (a_database: PS_REPOSITORY; a_tuple_query: PS_TUPLE_QUERY [AE_DATA_IDENTIFIED]): INTEGER_64
			-- Minimum `primary_key' value from some DATA_IDENTIFIED class.
		note
			purpose: "[
				To measure the smallest primary key in `a_database' for the OBJ of `a_tuple_query' generic.
				]"
			how: "[
				By use of a flag (`l_tested') and presumption of data ("Result := 1"), the routine attempts
				to show what the smallest value is (presuming 1). If no data is returned from the query,
				then the assumption is false and the value of Result reset to zero (0). This assumption is
				contracted in the check assertion ("zero_primary") to ensure it.
				]"
		local
			l_projection: ARRAYED_LIST [STRING]
			l_tested: BOOLEAN
		do
			create l_projection.make_from_array (<<{AE_DATA_IDENTIFIED}.primary_key_name>>)
			a_tuple_query.set_projection (l_projection)
			a_database.execute_tuple_query (a_tuple_query)
			Result := 1 -- Presumes a result set
			across a_tuple_query as ic_cursor loop
				if attached {INTEGER_64} ic_cursor.item.item (1) as al_item and then al_item < Result then
					Result := al_item
					l_tested := True
				end
			end
			a_tuple_query.close
			if not l_tested and Result = 1 then
				Result := {AE_DATA_IDENTIFIED}.no_primary_key
			end
			check zero_primary: l_tested implies Result > {AE_DATA_IDENTIFIED}.no_primary_key end
		end

end
