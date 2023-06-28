import type { Database } from '$lib/database.types';

export type ItemView = Database['public']['Views']['item_view'];
export type Category = Database['public']['Tables']['category'];
export type Location = Database['public']['Tables']['location'];
