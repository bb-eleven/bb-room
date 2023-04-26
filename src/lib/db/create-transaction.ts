import { supabase } from '$lib/supabase-client';
import type { TransactionDetail } from '$lib/types/transaction';
import { inou } from '$lib/utils';
import { DbFunction } from './functions';

export const createTransaction = async (
	author: string,
	transactionDetails: TransactionDetail[],
) => {
	const { data, error } = await supabase.from('transaction').insert({ author }).select();
	if (inou(data) || error) {
		throw new Error('error creating transaction');
	}
	console.log(data, error);
	const transaction = data[0];

	const errorRecords = [];

	for (const transactionDetail of transactionDetails) {
		let { item_variant_id, quantity, from_location_id, to_location_id } = transactionDetail;
		if (inou(from_location_id) && inou(to_location_id)) {
			errorRecords.push({
				message: 'from_location_id and to_location_id cannot be null at the same time',
				record: transactionDetail,
			});
			continue;
		}

		quantity = Math.abs(quantity);

		const { data, error } = await supabase.from('transaction_detail').insert({
			transaction_id: transaction.id,
			...transactionDetail,
		});
		console.log(data, error);

		if (!inou(from_location_id)) {
			// TODO: check if quantity is greater than current_quantity

			const { data, error } = await supabase.rpc(DbFunction.UpdateLocationQuantity, {
				_location_id: from_location_id,
				_item_variant_id: item_variant_id,
				delta_quantity: -quantity,
			});
			console.log(data, error);
		}

		if (!inou(to_location_id)) {
			const { data, error } = await supabase.rpc(DbFunction.UpdateLocationQuantity, {
				_location_id: to_location_id,
				_item_variant_id: item_variant_id,
				delta_quantity: quantity,
			});
			console.log(data, error);
		}
	}
};
