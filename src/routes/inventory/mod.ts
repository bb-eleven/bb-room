import type { Category, Location } from '$lib/database.types.short';
import type { Database } from '$lib/database.types';
import { ninou } from '$lib/utils';
import type { SupabaseClient } from '@supabase/supabase-js';

// Locations MultiSelect
export const getLocationsOptionDisplay = (selected?: Location['Row']) => selected?.code ?? '';
export const getLocationsInputDisplay = (selected?: Location['Row'][]) =>
	ninou(selected) && selected.length > 0 ? selected.map((l) => l.code).join(', ') : 'Select';

// Categories MultiSelect
export const getCategoriesOptionDisplay = (selected?: Category['Row']) => selected?.name ?? '';
export const getCategoriesInputDisplay = (selected?: Category['Row'][]) =>
	ninou(selected) && selected.length > 0 ? selected.map((c) => c.name).join(', ') : 'Select';

export const getItemViews = async (supabase: SupabaseClient<Database>) => {
	const { data: itemViews, error } = await supabase.from('item_view').select();
	return itemViews;
};
