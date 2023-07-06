import type { ItemView } from '$lib/database.types.short';
import { inout, iu } from '$lib/utils';
import type { Author, CreateNewTransactionArgs, ItemViewCreateTransactionDetail } from './types';
import type { Database } from '$lib/database.types';
import type { SupabaseClient } from '@supabase/supabase-js';
import type { Nullable } from 'vitest';

export const getLocationCodesInputDisplay = (selected: Nullable<string>) =>
	iu(selected) ? 'Select' : selected === null ? 'Outside' : selected;
export const getLocationCodesOptionDisplay = (option: Nullable<string>) => inout(option, 'Outside');

export const mapToItemViewCreateTransactionDetail = (
	itemView: ItemView['Row'],
): ItemViewCreateTransactionDetail => {
	const { id, category_ids, location_codes, ...itemViewOmitted } = itemView;
	return {
		...itemViewOmitted,
		item_id: inout(id, 0),
		quantity: 0,
		from_location_code: undefined as any,
		to_location_code: undefined as any,
		from_location_codes: [null, ...inout(location_codes, [])],
		errors: {},
	};
};

const mapToCreateNewTransactionArgs = (
	author: Required<Author>,
	itemViewCreateTransactionDetails: ItemViewCreateTransactionDetail[],
): CreateNewTransactionArgs => ({
	_author: author.value,
	create_transaction_details: itemViewCreateTransactionDetails.map(
		({ item_id, quantity, from_location_code, to_location_code }) => ({
			item_id,
			quantity,
			from_location_code,
			to_location_code,
		}),
	),
});

export const createTransaction = async (
	supabase: SupabaseClient<Database>,
	author: Required<Author>,
	itemViewCreateTransactionDetails: ItemViewCreateTransactionDetail[],
) => {
	return await supabase.rpc(
		'create_new_transaction',
		mapToCreateNewTransactionArgs(author, itemViewCreateTransactionDetails),
	);
};
