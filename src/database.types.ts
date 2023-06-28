export type Json = string | number | boolean | null | { [key: string]: Json } | Json[];

export interface Database {
	graphql_public: {
		Tables: {
			[_ in never]: never;
		};
		Views: {
			[_ in never]: never;
		};
		Functions: {
			graphql: {
				Args: {
					operationName?: string;
					query?: string;
					variables?: Json;
					extensions?: Json;
				};
				Returns: Json;
			};
		};
		Enums: {
			[_ in never]: never;
		};
		CompositeTypes: {
			[_ in never]: never;
		};
	};
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
			};
			transaction: {
				Row: {
					author: string;
					id: number;
					timestamp: string;
				};
				Insert: {
					author: string;
					id?: number;
					timestamp?: string;
				};
				Update: {
					author?: string;
					id?: number;
					timestamp?: string;
				};
			};
			transaction_detail: {
				Row: {
					from_location_id: number | null;
					item_id: number;
					quantity: number;
					to_location_id: number | null;
					transaction_id: number;
				};
				Insert: {
					from_location_id?: number | null;
					item_id: number;
					quantity: number;
					to_location_id?: number | null;
					transaction_id: number;
				};
				Update: {
					from_location_id?: number | null;
					item_id?: number;
					quantity?: number;
					to_location_id?: number | null;
					transaction_id?: number;
				};
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
			create_new_transaction: {
				Args: {
					_author: string;
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
	storage: {
		Tables: {
			buckets: {
				Row: {
					allowed_mime_types: string[] | null;
					avif_autodetection: boolean | null;
					created_at: string | null;
					file_size_limit: number | null;
					id: string;
					name: string;
					owner: string | null;
					public: boolean | null;
					updated_at: string | null;
				};
				Insert: {
					allowed_mime_types?: string[] | null;
					avif_autodetection?: boolean | null;
					created_at?: string | null;
					file_size_limit?: number | null;
					id: string;
					name: string;
					owner?: string | null;
					public?: boolean | null;
					updated_at?: string | null;
				};
				Update: {
					allowed_mime_types?: string[] | null;
					avif_autodetection?: boolean | null;
					created_at?: string | null;
					file_size_limit?: number | null;
					id?: string;
					name?: string;
					owner?: string | null;
					public?: boolean | null;
					updated_at?: string | null;
				};
			};
			migrations: {
				Row: {
					executed_at: string | null;
					hash: string;
					id: number;
					name: string;
				};
				Insert: {
					executed_at?: string | null;
					hash: string;
					id: number;
					name: string;
				};
				Update: {
					executed_at?: string | null;
					hash?: string;
					id?: number;
					name?: string;
				};
			};
			objects: {
				Row: {
					bucket_id: string | null;
					created_at: string | null;
					id: string;
					last_accessed_at: string | null;
					metadata: Json | null;
					name: string | null;
					owner: string | null;
					path_tokens: string[] | null;
					updated_at: string | null;
					version: string | null;
				};
				Insert: {
					bucket_id?: string | null;
					created_at?: string | null;
					id?: string;
					last_accessed_at?: string | null;
					metadata?: Json | null;
					name?: string | null;
					owner?: string | null;
					path_tokens?: string[] | null;
					updated_at?: string | null;
					version?: string | null;
				};
				Update: {
					bucket_id?: string | null;
					created_at?: string | null;
					id?: string;
					last_accessed_at?: string | null;
					metadata?: Json | null;
					name?: string | null;
					owner?: string | null;
					path_tokens?: string[] | null;
					updated_at?: string | null;
					version?: string | null;
				};
			};
		};
		Views: {
			[_ in never]: never;
		};
		Functions: {
			can_insert_object: {
				Args: {
					bucketid: string;
					name: string;
					owner: string;
					metadata: Json;
				};
				Returns: undefined;
			};
			extension: {
				Args: {
					name: string;
				};
				Returns: string;
			};
			filename: {
				Args: {
					name: string;
				};
				Returns: string;
			};
			foldername: {
				Args: {
					name: string;
				};
				Returns: string[];
			};
			get_size_by_bucket: {
				Args: Record<PropertyKey, never>;
				Returns: {
					size: number;
					bucket_id: string;
				}[];
			};
			search: {
				Args: {
					prefix: string;
					bucketname: string;
					limits?: number;
					levels?: number;
					offsets?: number;
					search?: string;
					sortcolumn?: string;
					sortorder?: string;
				};
				Returns: {
					name: string;
					id: string;
					updated_at: string;
					created_at: string;
					last_accessed_at: string;
					metadata: Json;
				}[];
			};
		};
		Enums: {
			[_ in never]: never;
		};
		CompositeTypes: {
			[_ in never]: never;
		};
	};
}
