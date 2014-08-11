note
	description: "[
		ABEL Extension for accessing object-agnostic data in a database.
		]"
	purpose: "[
		To facilitate object-agnostic access to data contained in some PS_REPOSITORY.
		]"
	how: "[
		By using database and query references to take action in
		ways that accomplish the goal of each feature, where the goal is
		either answering some question like MIN, MAX, COUNT, AVERAGE, etc.,
		or returning some result-set of objects.
		]"
	glossary: "[
		object-agnostic: Access to the backend database that is not based on a known
			or specific object (from this libraries point of view). For example:
			the feature `maximum_primary_key' only cares that the object is 
			AE_DATA_IDENTIFIED and is unconcerned with a specific type.
		]"
	todos: "[
		2014 August: Consider other functions like STDEV (Standard Deviation) and other math
						as well as financial functions.
		]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	AE_DATA_ACCESSOR

feature -- Access

	average (a_database: PS_REPOSITORY; a_tuple_query: PS_TUPLE_QUERY [AE_DATA_IDENTIFIED]; a_field_name: STRING): TUPLE [t_average, t_total, t_count: REAL]
			-- Calculate the average of `a_field_name', based on objects in `a_tuple_query' from `a_database'.
		note
			how: "[
				By executing `a_tuple_query' against `a_field_name', which must be NUMERIC (see cautions note). The
				Result information includes the average, the total used to calculate it, as well as the count used.
				]"
			cautions: "[
				Presently, you can only average NUMERIC fields.
				]"
			todos: "[
				2014 August: Consider being able to average DECIMAL and MIXED_NUMBER types as well.
				]"
			inspector: "[
				2014 August: The use of `l_dummy' satisfies the Eiffel Inspector code analyzer. If the local,
								Result of the `execute_tuple_query_on_database' call, and attachment check are
								removed, then there are complaints for broken CQS.
				]"
			glossary: "[
				CQS: Command–query separation (CQS) is a principle of imperative computer programming. It was 
						devised by Bertrand Meyer as part of his pioneering work on the Eiffel programming language.
						It states that every method should either be a command that performs an action, or a query 
						that returns data to the caller, but not both. In other words, asking a question should not 
						change the answer. More formally, methods should return a value only if they are referentially 
						transparent and hence possess no side effects.
				]"
			EIS: "name=CQS", "protocol=URI", "tag=glossary", "src=http://en.wikipedia.org/wiki/Command-query_separation"
		local
			l_counter: INTEGER
			l_total: REAL
			l_dummy: detachable ANY
		do
			l_dummy := execute_tuple_query_on_database (a_database, a_tuple_query, <<a_field_name>>)
			if attached l_dummy then l_dummy.do_nothing end
			across a_tuple_query as ic_cursor loop
				l_counter := l_counter + 1
				if attached {REAL} ic_cursor.item.item (first_tuple_item) as al_value then
					l_total := l_total + al_value
				elseif attached {INTEGER} ic_cursor.item.item (first_tuple_item) as al_value then
					l_total := l_total + al_value.to_real
				elseif attached {INTEGER_32} ic_cursor.item.item (first_tuple_item) as al_value then
					l_total := l_total + al_value.to_real
				elseif attached {INTEGER_64} ic_cursor.item.item (first_tuple_item) as al_value then
					l_total := l_total + al_value.to_real
				elseif attached {NATURAL_8} ic_cursor.item.item (first_tuple_item) as al_value then
					l_total := l_total + al_value.to_real_32
				elseif attached {NATURAL_16} ic_cursor.item.item (first_tuple_item) as al_value then
					l_total := l_total + al_value.to_real_32
				elseif attached {NATURAL_32} ic_cursor.item.item (first_tuple_item) as al_value then
					l_total := l_total + al_value.to_real_32
				elseif attached {NATURAL_64} ic_cursor.item.item (first_tuple_item) as al_value then
					l_total := l_total + al_value.to_real_32
				end
			end
			a_tuple_query.close
			Result := [l_total / l_counter.to_real, l_total, l_counter.to_real]
		end

	count (a_database: PS_REPOSITORY; a_tuple_query: PS_TUPLE_QUERY [AE_DATA_IDENTIFIED]): INTEGER
			-- Count of objects returned from `a_database' for `a_tuple_query'.
		note
			how: "[
				By counting the unique primary keys.
				]"
			todos: "[
				2014 August: One may want a count based on another query other than primary keys.
				]"
			inspector: "[
				2014 August: The use of `l_dummy' satisfies the Eiffel Inspector code analyzer. If the local,
								Result of the `execute_tuple_query_on_database' call, and attachment check are
								removed, then there are complaints for broken CQS.
				]"
			glossary: "[
				CQS: Command–query separation (CQS) is a principle of imperative computer programming. It was 
						devised by Bertrand Meyer as part of his pioneering work on the Eiffel programming language.
						It states that every method should either be a command that performs an action, or a query 
						that returns data to the caller, but not both. In other words, asking a question should not 
						change the answer. More formally, methods should return a value only if they are referentially 
						transparent and hence possess no side effects.
				]"
			EIS: "name=CQS", "protocol=URI", "tag=glossary", "src=http://en.wikipedia.org/wiki/Command-query_separation"
		local
			l_dummy: detachable ANY
		do
			l_dummy := execute_tuple_query_on_database (a_database, a_tuple_query, <<{AE_DATA_IDENTIFIED}.primary_key_name>>)
			if attached l_dummy then l_dummy.do_nothing end
			across a_tuple_query as ic_cursor loop
				Result := Result + 1
			end
			a_tuple_query.close
		end

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
			inspector: "[
				2014 August: The use of `l_dummy' satisfies the Eiffel Inspector code analyzer. If the local,
								Result of the `execute_tuple_query_on_database' call, and attachment check are
								removed, then there are complaints for broken CQS.
				]"
			glossary: "[
				CQS: Command–query separation (CQS) is a principle of imperative computer programming. It was 
						devised by Bertrand Meyer as part of his pioneering work on the Eiffel programming language.
						It states that every method should either be a command that performs an action, or a query 
						that returns data to the caller, but not both. In other words, asking a question should not 
						change the answer. More formally, methods should return a value only if they are referentially 
						transparent and hence possess no side effects.
				Magic-numbers: In computer programming, the term magic number has multiple meanings. It could refer to one or more 
						of the following:
						* A constant numerical or text value used to identify a file format or protocol; for files, see List of file 
							signatures
						* Distinctive unique values that are unlikely to be mistaken for other meanings (e.g., Globally Unique Identifiers)
						* Unique values with unexplained meaning or multiple occurrences which could (preferably) be replaced with 
							named constants
				]"
			EIS: "name=CQS", "protocol=URI", "tag=glossary", "src=http://en.wikipedia.org/wiki/Command-query_separation"
			EIS: "name=Magic_numbers", "protocol=URI", "src=http://en.wikipedia.org/wiki/Magic_number_(programming)", "tag=wikipedia"
		local
			l_dummy: detachable ANY
		do
			l_dummy := execute_tuple_query_on_database (a_database, a_tuple_query, <<{AE_DATA_IDENTIFIED}.primary_key_name>>)
			if attached l_dummy then l_dummy.do_nothing end
			across a_tuple_query as ic_cursor loop
				if attached {INTEGER_64} ic_cursor.item.item (first_tuple_item) as al_item and then al_item > Result then
					Result := al_item
				end
			end
			a_tuple_query.close
		end

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
			inspector: "[
				2014 August: The use of `l_dummy' satisfies the Eiffel Inspector code analyzer. If the local,
								Result of the `execute_tuple_query_on_database' call, and attachment check are
								removed, then there are complaints for broken CQS.
				]"
			glossary: "[
				CQS: Command–query separation (CQS) is a principle of imperative computer programming. It was 
						devised by Bertrand Meyer as part of his pioneering work on the Eiffel programming language.
						It states that every method should either be a command that performs an action, or a query 
						that returns data to the caller, but not both. In other words, asking a question should not 
						change the answer. More formally, methods should return a value only if they are referentially 
						transparent and hence possess no side effects.
				]"
			EIS: "name=CQS", "protocol=URI", "tag=glossary", "src=http://en.wikipedia.org/wiki/Command-query_separation"
		local
			l_tested: BOOLEAN
			l_dummy: detachable ANY
		do
			l_dummy := execute_tuple_query_on_database (a_database, a_tuple_query, <<{AE_DATA_IDENTIFIED}.primary_key_name>>)
			if attached l_dummy then l_dummy.do_nothing end
			Result := 1 -- Presumes a result set
			across a_tuple_query as ic_cursor loop
				if attached {INTEGER_64} ic_cursor.item.item (1) as al_item and then al_item <= Result then
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

feature -- Constants

	first_tuple_item: INTEGER = 1
			-- A counter representing item #1 in a TUPLE. See client accessors usage for example.

feature {NONE} -- Implementation

	execute_tuple_query_on_database (a_database: PS_REPOSITORY; a_tuple_query: PS_TUPLE_QUERY [AE_DATA_IDENTIFIED]; a_fields: ARRAY [STRING]): detachable ANY
			-- Execute `a_tuple_query' on `a_database', possibly returning a result set of `a_fields'.
		note
			how: "[
				By executing `a_tuple_query' and returning `a_fields' as a collection in the query from `a_database' source.
				Note that there is no Result as the passed query is "loaded" with the result set.
				]"
			inspector: "[
				2014 August: Function 'average' contains a procedure call, assigns to an attribute, or
								creates an attribute. This indicates that the function changes the state of the
								object, which is a violation of the command-query separation principle. This is
								true for all routines calling this function. The problem is with having no Result
								and the results being contained in the a_tuple_query argument.
				]"
		do
			a_tuple_query.set_projection (create {ARRAYED_LIST [STRING]}.make_from_array (a_fields))
			a_database.execute_tuple_query (a_tuple_query)
			Result := Void
		end

end
