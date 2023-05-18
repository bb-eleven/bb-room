import { writable } from 'svelte/store';

export const UsernameStore = writable<string | null>();
