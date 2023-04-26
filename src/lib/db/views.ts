export enum DbView {
  Item = 'item_view',
  ItemVariant = 'item_variant_view'
};

export type ItemView = {
  item_name: string,
  category_names: string[],
  category_ids: number[]
};

export type ItemVariantView = {
  item_name: string,
  variant_name: string,
  category_names: string[],
  category_ids: number[]
};

