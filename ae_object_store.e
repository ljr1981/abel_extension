note
	title: "[
		ABEL Extension Object Store
		]"
	description: "[
		Abstraction for fetching (potential) objects of type OBJ from a database.
		]"
	purpose: "[
		To access a database and pull from it an object upon some basis (usually a query).
		]"
	usage: "[
		The intent of this class is to facilitate objects storing `primary_key' references
		to other objects, rather than direct references, where ABEL will attempt to persist
		the object reference itself. Thus, a parent (enclosing) class will have a feature
		like `my_child_id: INTEGER_64', which has the `a_id' of the child. The class then
		has an additional feature like:
		
		my_child_id: INTEGER_64
				-- Database primary key of `my_child'.
		
		my_child: MY_CHILD
			do
				if my_child_id > 0 then
					Result := (create {OBJECT_STORE [MY_CHILD]}).object_for_id (some_database_feature, my_child_id)
				end
			end
			
		The corresponding setter--`set_my_child (a_child: MY_CHILD)' will not only put the
		instance of `a_child' to the database, but will update is `my_child_id' with the
		primary key number of the persisted object. Moreover, the host class of `my_child',
		must either already be in the database and updated, or persisted immediately after
		all children have been persisted. If something interrupts this process, then one
		will need to roll the transactions back on the children.
		]"
	todos: "[
		2014 August: Possibly create some class which represents an AE_DATA_IDENTIFIED object
			reference to be used on a parent class needing a child feature, where the object
			is stored to the database with a primary key. This class will have all it needs
			for "load-on-demand" (lazy instantiation) as well as setting (saving) and coordination
			with the parent in both persisting and rolling back if needed.
		]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	AE_OBJECT_STORE [OBJ -> AE_DATA_IDENTIFIED]

feature -- Basic Operations

	attached_object_for_id (a_database: PS_REPOSITORY; a_id: INTEGER_64): OBJ
			-- An attached version of `object_for_id'.
		note
			how: "[
				By a dependency on `object_for_id' to return an attached Result. Thus, onus is
				on the host application to ensure referential integrity (i.e. an object of type
				OBJ is in `a_database' with `a_id' as the primary_key)
				]"
		require
			has_id: a_id > 0
		do
			check has_object: attached object_for_id (a_database, a_id) as al_result then Result := al_result  end
		end

	object_for_id (a_database: PS_REPOSITORY; a_id: INTEGER_64): detachable OBJ
			-- An OBJ for some `a_id' possibly in `a_database'.
		note
			how: "[
				By querying `a_database' for an OBJ with `a_id' as the primary key.
				]"
			cautions: "[
				There are three ways for this query routine to fail:
				
				1. An object of type OBJ is not in `a_database', regardless of the `a_id'.
				2. An object of type OBJ IS in `a_database', but not one with a primary key of `a_id'.
				3. If there is an error accessing or working with the database.
				
				Any of these conditions will Result in a detached (void) return.
				]"
		require
			has_id: a_id > 0
		local
			l_query: PS_QUERY [OBJ]
			l_transaction: PS_TRANSACTION
		do
			create l_query.make
			l_transaction := a_database.new_transaction
			l_query.set_criterion (create {PS_PREDEFINED_CRITERION}.make ({AE_DATA_IDENTIFIED}.primary_key_name, {PS_CRITERION_FACTORY}.Equals, a_id))
			l_transaction.execute_query (l_query)
			if not l_transaction.has_error then
				across l_query as ic_query loop
					if attached {OBJ} ic_query.item as al_result then
						Result := al_result
					end
				end
			else
				-- TODO: Do we want to do something about database failures?
			end
		end

end
