import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals: { supabase } }) => {
	const locations = (await supabase.from('location').select()).data ?? [];

	return { locationCodes: [null, ...locations.map(({ code }) => code)] };
};
