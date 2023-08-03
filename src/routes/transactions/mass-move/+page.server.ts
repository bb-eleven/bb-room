import type { LocationCodeQuantity } from '../create/types';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({
	locals: { supabase },
}): Promise<{ locationCodeQuantities: LocationCodeQuantity[] }> => {
	const locations = (await supabase.from('location').select()).data ?? [];

	return {
		locationCodeQuantities: [
			{ code: null, quantity: null },
			...locations.map(({ code }) => ({ code, quantity: null })),
		],
	};
};
