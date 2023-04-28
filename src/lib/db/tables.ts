export enum DbTables {
  Item = 'item',
  Category = 'category',
  ItemCategory = 'item_category',
  Location = 'location',
  ItemLocation = 'item_location',
  Transaction = 'transaction',
  TransactionDetail = 'transaction_detail'
}

export type Category = {
  id: number;
  name: string;
}

export type Location = {
  id: number;
  code: string;
  description?: string;
}

export type CreateTransaction = {
  id: number;
  author: string;
}

export type Transaction = CreateTransaction & {
  timestamp: Date;
}

export type TransactionDetail = {
  transaction_id?: number;
  item_id: number;
  quantity: number;
  from_location_id?: number;
  to_location_id?: number;
};
