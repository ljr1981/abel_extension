note
	description: "[
		Abstraction of an Object Store feature.
		]"
	purpose: "[
		To apply features to a parent object where the
		contained feature has code facilities to manage
		the feature in a AE_DATA_IDENTIFIED and an
		AE_OBJECT_STORE context.
		]"
	how: "[
		By supplying features like `item_id' and `item',
		where the ID points to an OBJ in `a_database' and
		the `item' feature pulls that object form `a_database'
		based on the `primary_key' (aka ID or `item_id').
		It also supplies a "setter" feature as well.
		
		By also supplying all database coordination for
		accessing the object if it is persisted to the
		database (assumed to be true in all cases).
		]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AE_OBJECT_STORE_FEATURE [OBJ -> AE_DATA_IDENTIFIED]

feature -- Access

	item_id: INTEGER_64
			-- The `primary_key' value of the child.

	existing_item: OBJ
			-- An `item' that must exist in the `database'.
		require
			has_database: attached database
			has_child_id: item_id > 0
		do
			check attached item as al_child then Result := al_child end
		end

	item: detachable OBJ
			-- An `item' that may or may not be in the `database' of Current.
		note
			cautions: "[
				There are three ways for this query routine to fail:

				1. An object of type OBJ is not in `a_database', regardless of the `item_id'.
				2. An object of type OBJ IS in `a_database', but not one with a primary key of `item_id'.
				3. If there is an error accessing or working with the database.

				Any of these conditions will Result in a detached (void) return.
				]"
			see_also: "[
				See AE_OBJECT_STORE.object_for_id (see code call below).
				]"
		do
			if item_id >= 1 and then attached database as al_database then
				Result := (create {AE_OBJECT_STORE [OBJ]}).object_for_id (al_database, item_id)
			end
		end

feature -- Settings

	set_item (a_database: attached like database; a_item: attached like item)
			-- Set `a_item' into `item' using `a_transaction' based on some database.
		note
			cautions: "[
				The `a_transaction' will most likely need to be 'prepared'
				(see PS_TRANSACTION.prepare), which discards any active
				queries, which is what the require contract below is about.
				
				This routine also handles setting the primary key on
				`a_item' before inserting it into `a_database'.
				]"
			todos: "[
				The setting of the object into the database of the transaction
				is not a certainty where "design" of this class is concerned.
				Performing the `insert' in this code might presume too much
				where a failure would portend a need for a "rollback".
				]"
		local
			l_transaction: PS_TRANSACTION
		do
			database := a_database
			l_transaction := a_database.new_transaction
			a_item.set_primary_key_from_database (a_database)
			l_transaction.insert (a_item)
			l_transaction.commit
			item_id := a_item.primary_key
		ensure
			database_set: attached database as al_database and then al_database ~ a_database
			item_set:attached item  as al_item
							and then al_item.primary_key = item_id
		end

feature -- Database

	database: detachable PS_REPOSITORY
			-- Database reference for Current.

end
