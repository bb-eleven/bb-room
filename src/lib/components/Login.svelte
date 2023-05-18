<script lang="ts">
	import type { AuthError, AuthResponse, SupabaseClient } from '@supabase/supabase-js';
	import SearchBar from './SearchBar.svelte';
	import type { Database } from '$lib/database.types';
	import Button from './Button.svelte';
	import { inou, ninou } from '$lib/utils';

	export let supabase: SupabaseClient<Database>;
	let username: string;
	let password: string;
	export let loggedInUsername: string | null = null;
	export let error: AuthError | null = null;
	let success = false;

	const login = async () => {
		const res = await supabase.auth.signInWithPassword({ email: username, password });
		error = res.error;
		if (ninou(error)) {
			success = false;
		} else {
			success = true;
			loggedInUsername = username;
			username = '';
			password = '';
		}
	};
</script>

<div class="p-4 gap-4 bg-mirage rounded-2xl flex flex-col {$$props.class}">
	{#if error}
		<div class="rounded-lg p-2 bg-red text-cultured">
			{error.message}
		</div>
	{/if}
	{#if success}
		<div class="rounded-lg p-2 bg-envy text-cultured">
			Successfully logged in as "{loggedInUsername}"
		</div>
	{/if}
	<SearchBar bind:search={username} placeholder="username" />
	<SearchBar bind:search={password} placeholder="password" type="password" />
	<Button text="Login" click={login} class="block mt-4 self-center" />
</div>
