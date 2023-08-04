export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export interface Database {
	public: {
		Tables: {
			category: {
				Row: {
					id: number;
					name: string;
				};
				Insert: {
					id?: number;
					name: string;
				};
				Update: {
					id?: number;
					name?: string;
				};
				Relationships: [];
			};
			item: {
				Row: {
					id: number;
					initial_quantity: number;
					name: string | null;
					quantity_metric: string | null;
					variant_name: string | null;
				};
				Insert: {
					id?: number;
					initial_quantity: number;
					name?: string | null;
					quantity_metric?: string | null;
					variant_name?: string | null;
				};
				Update: {
					id?: number;
					initial_quantity?: number;
					name?: string | null;
					quantity_metric?: string | null;
					variant_name?: string | null;
				};
				Relationships: [];
			};
			item_category: {
				Row: {
					category_id: number;
					item_id: number;
				};
				Insert: {
					category_id: number;
					item_id: number;
				};
				Update: {
					category_id?: number;
					item_id?: number;
				};
				Relationships: [
					{
						foreignKeyName: 'item_category_category_id_fkey';
						columns: ['category_id'];
						referencedRelation: 'category';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'item_category_item_id_fkey';
						columns: ['item_id'];
						referencedRelation: 'item';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'item_category_item_id_fkey';
						columns: ['item_id'];
						referencedRelation: 'item_view';
						referencedColumns: ['id'];
					},
				];
			};
			item_location: {
				Row: {
					item_id: number;
					location_id: number;
					quantity: number;
				};
				Insert: {
					item_id: number;
					location_id: number;
					quantity: number;
				};
				Update: {
					item_id?: number;
					location_id?: number;
					quantity?: number;
				};
				Relationships: [
					{
						foreignKeyName: 'item_location_item_id_fkey';
						columns: ['item_id'];
						referencedRelation: 'item';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'item_location_item_id_fkey';
						columns: ['item_id'];
						referencedRelation: 'item_view';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'item_location_location_id_fkey';
						columns: ['location_id'];
						referencedRelation: 'location';
						referencedColumns: ['id'];
					},
				];
			};
			location: {
				Row: {
					code: string;
					description: string | null;
					id: number;
				};
				Insert: {
					code: string;
					description?: string | null;
					id?: number;
				};
				Update: {
					code?: string;
					description?: string | null;
					id?: number;
				};
				Relationships: [];
			};
			transaction: {
				Row: {
					author: string;
					id: number;
					purpose: string;
					timestamp: string;
				};
				Insert: {
					author: string;
					id?: number;
					purpose: string;
					timestamp?: string;
				};
				Update: {
					author?: string;
					id?: number;
					purpose?: string;
					timestamp?: string;
				};
				Relationships: [];
			};
			transaction_detail: {
				Row: {
					from_location_id: number | null;
					item_id: number;
					new_from_quantity: number | null;
					new_to_quantity: number | null;
					quantity_moved: number;
					to_location_id: number | null;
					transaction_id: number;
				};
				Insert: {
					from_location_id?: number | null;
					item_id: number;
					new_from_quantity?: number | null;
					new_to_quantity?: number | null;
					quantity_moved: number;
					to_location_id?: number | null;
					transaction_id: number;
				};
				Update: {
					from_location_id?: number | null;
					item_id?: number;
					new_from_quantity?: number | null;
					new_to_quantity?: number | null;
					quantity_moved?: number;
					to_location_id?: number | null;
					transaction_id?: number;
				};
				Relationships: [
					{
						foreignKeyName: 'transaction_detail_from_location_id_fkey';
						columns: ['from_location_id'];
						referencedRelation: 'location';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'transaction_detail_item_id_fkey';
						columns: ['item_id'];
						referencedRelation: 'item';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'transaction_detail_item_id_fkey';
						columns: ['item_id'];
						referencedRelation: 'item_view';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'transaction_detail_to_location_id_fkey';
						columns: ['to_location_id'];
						referencedRelation: 'location';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'transaction_detail_transaction_id_fkey';
						columns: ['transaction_id'];
						referencedRelation: 'transaction';
						referencedColumns: ['id'];
					},
				];
			};
		};
		Views: {
			item_view: {
				Row: {
					category_ids: number[] | null;
					category_names: string[] | null;
					id: number | null;
					location_codes: string[] | null;
					location_quantities: number[] | null;
					name: string | null;
					variant_name: string | null;
				};
				Relationships: [];
			};
		};
		Functions: {
			_update_location_quantity: {
				Args: {
					_item_id: number;
					_location_id: number;
					delta_quantity: number;
				};
				Returns: number;
			};
			citext:
				| {
						Args: {
							'': string;
						};
						Returns: string;
				  }
				| {
						Args: {
							'': boolean;
						};
						Returns: string;
				  }
				| {
						Args: {
							'': unknown;
						};
						Returns: string;
				  };
			citext_hash: {
				Args: {
					'': string;
				};
				Returns: number;
			};
			citextin: {
				Args: {
					'': unknown;
				};
				Returns: string;
			};
			citextout: {
				Args: {
					'': string;
				};
				Returns: unknown;
			};
			citextrecv: {
				Args: {
					'': unknown;
				};
				Returns: string;
			};
			citextsend: {
				Args: {
					'': string;
				};
				Returns: string;
			};
			create_new_transaction:
				| {
						Args: {
							_author: string;
							create_transaction_details: Database['public']['CompositeTypes']['create_transaction_detail'][];
						};
						Returns: number;
				  }
				| {
						Args: {
							_author: string;
							_purpose: string;
							create_transaction_details: Database['public']['CompositeTypes']['create_transaction_detail'][];
						};
						Returns: number;
				  };
			filter_item_view: {
				Args: {
					_name_query: string;
					_category_names: string[];
					_location_codes: string[];
				};
				Returns: {
					id: number;
					name: string;
					variant_name: string;
					category_ids: number[];
					category_names: string[];
					location_codes: string[];
					location_quantities: number[];
				}[];
			};
		};
		Enums: {
			[_ in never]: never;
		};
		CompositeTypes: {
			create_transaction_detail: {
				item_id: number;
				quantity: number;
				from_location_code: string;
				to_location_code: string;
			};
		};
	};
}
