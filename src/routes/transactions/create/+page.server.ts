import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals: { supabase } }) => {
	const locations = (await supabase.from('location').select()).data ?? [];

	return {
		locationCodeQuantities: [
			{ code: null, quantity: null },
			...locations.map(({ code }) => ({ code, quantity: null })),
		],
	};
};
