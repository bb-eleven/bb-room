import { DbTables, type Category, type Location } from '$lib/db/tables';
import { supabase } from '$lib/supabase-client';

export async function load() {
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
