import type { ItemView } from '$lib/database.types.short';
import type { Nullable } from 'vitest';
import type { Database } from '../../../database.types';
import type { ArrayElement } from '$lib/utils';

export type Author = { value?: string; error?: Nullable<string> };

export type CreateNewTransactionArgs =
	Database['public']['Functions']['create_new_transaction']['Args'];

export type CreateTransactionDetail = ArrayElement<
	CreateNewTransactionArgs['create_transaction_details']
>;

export type LocationCodeQuantity = { code: string | null; quantity: number | null };

export type ItemViewCreateTransactionDetail = Omit<
	ItemView['Row'],
	| 'id'
	| 'category_ids'
	| 'location_codes'
	| 'location_quantities'
	| 'from_location_code'
	| 'to_location_code'
> &
	Omit<CreateTransactionDetail, 'from_location_code' | 'to_location_code'> & {
		locationCodeQuantities: LocationCodeQuantity[];
		fromLocationCodeQuantity: Nullable<LocationCodeQuantity>;
		toLocationCodeQuantity: Nullable<LocationCodeQuantity>;
		errors: {
			[ErrorKey in keyof Pick<
				ItemViewCreateTransactionDetail,
				'fromLocationCodeQuantity' | 'toLocationCodeQuantity' | 'quantity'
			>]?: Nullable<string>;
		};
	};
