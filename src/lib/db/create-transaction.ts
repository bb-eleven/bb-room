import type { Database } from '$lib/database.types';
import { inou } from '$lib/utils';
import type { SupabaseClient } from '@supabase/supabase-js';
import { DbFunction, type CreateNewTransactionParams } from './functions';
import type { CreateTransactionDetail } from './tables';

export const createTransaction = async (
	supabase: SupabaseClient<Database>,
	author: string,
	createTransactionDetails: CreateTransactionDetail[],
) => {
	const errorRecords = [];

	for (const createTransactionDetail of createTransactionDetails) {
		let { item_id, quantity, from_location_code, to_location_code } = createTransactionDetail;
		if (inou(from_location_code) && inou(to_location_code)) {
			errorRecords.push({
				message: 'from_location_code and to_location_code cannot be "Outside" at the same time',
				record: createTransactionDetail,
			});
			continue;
		}
	}

	if (errorRecords.length === 0) {
		const params: CreateNewTransactionParams = {
			_author: author,
			create_transaction_details: createTransactionDetails,
		};
		const { data, error } = await supabase.rpc(DbFunction.CreateNewTransaction, params as any);
		console.log(data, error);
	} else {
		console.log(errorRecords);
	}
};
