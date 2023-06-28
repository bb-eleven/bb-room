import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals: { supabase } }) => {
	const categories = (await supabase.from('category').select()).data ?? [];
	const locations = (await supabase.from('location').select()).data ?? [];

	return { categories, locations };
};
