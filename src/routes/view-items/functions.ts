import type { Database } from '$lib/database.types';
import { type Category, DbTables, type Location } from '$lib/db/tables';
import type { SupabaseClient } from '@supabase/supabase-js';

export async function loadData(supabase: SupabaseClient<Database>) {
	let categories: Category[];
	let locations: Location[];

	{
		const { data, error } = await supabase.from(DbTables.Category).select();
		categories = data as Category[];
	}

	{
		const { data, error } = await supabase.from(DbTables.Location).select();
		locations = data as Location[];
	}

	return { categories, locations };
}
