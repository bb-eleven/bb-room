export enum DbView {
	Item = 'item_view',
}

export type ItemView = {
	id: number;
	name: string;
	variant_name?: string;
	category_ids?: number[];
	category_names?: string[];
	location_codes?: string[];
	location_quantities?: number[];
};
