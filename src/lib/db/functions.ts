import type { CreateTransactionDetail } from './tables';

export enum DbFunction {
	FilterItemView = 'filter_item_view',
	CreateNewTransaction = 'create_new_transaction',
}

export type CreateNewTransactionParams = {
	_author: string;
	create_transaction_details: CreateTransactionDetail[];
};
