import { DbTables, type Category, type Location } from '$lib/db/tables';
import { DbView, type ItemView } from '$lib/db/views';
import { supabase } from '$lib/supabase-client';

export async function load() {
	let itemViews: ItemView[];
	let categories: Category[];
	let locations: Location[];

	{
		const { data, error } = await supabase.from(DbView.Item).select();
		itemViews = data as ItemView[];
	}

	{
		const { data, error } = await supabase.from(DbTables.Category).select();
		categories = data as Category[];
	}

	{
		const { data, error } = await supabase.from(DbTables.Location).select();
		locations = data as Location[];
	}

	return { itemViews, categories, locations };
}
