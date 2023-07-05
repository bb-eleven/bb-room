import type { ItemView } from '$lib/database.types.short';
import type { Nullable } from 'vitest';
import type { Database } from '../../database.types';

type ArrayElement<ArrayType extends readonly unknown[]> = ArrayType extends readonly (infer T)[]
	? T
	: never;

export type CreateNewTransactionArgs =
	Database['public']['Functions']['create_new_transaction']['Args'];
export type CreateTransactionDetail = ArrayElement<
	CreateNewTransactionArgs['create_transaction_details']
>;

type IV = Omit<ItemView['Row'], 'id' | 'category_ids' | 'location_codes'>;
export type ItemViewCreateTransactionDetail = IV &
	CreateTransactionDetail & {
		from_location_codes: Nullable<string>[];
		errors: {
			[ErrorKey in keyof Pick<
				ItemViewCreateTransactionDetail,
				'from_location_code' | 'to_location_code' | 'quantity'
			>]?: Nullable<string>;
		};
	};

export type Author = { value?: string; error?: Nullable<string> };
