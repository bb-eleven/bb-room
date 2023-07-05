import type { ItemView } from '$lib/database.types.short';
import type { Nullable } from 'vitest';
import type { Database } from '../../database.types';
import type { ArrayElement } from '$lib/utils';

export type Author = { value?: string; error?: Nullable<string> };

export type CreateNewTransactionArgs =
	Database['public']['Functions']['create_new_transaction']['Args'];

export type CreateTransactionDetail = ArrayElement<
	CreateNewTransactionArgs['create_transaction_details']
>;

export type ItemViewCreateTransactionDetail = Omit<
	ItemView['Row'],
	'id' | 'category_ids' | 'location_codes'
> &
	CreateTransactionDetail & {
		from_location_codes: Nullable<string>[];
		errors: {
			[ErrorKey in keyof Pick<
				ItemViewCreateTransactionDetail,
				'from_location_code' | 'to_location_code' | 'quantity'
			>]?: Nullable<string>;
		};
	};
