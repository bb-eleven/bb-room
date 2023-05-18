<script lang="ts">
	import Login from '$lib/components/Login.svelte';
	import { UsernameStore } from '$lib/stores/username';
	import { inou, ninou } from '$lib/utils';
	import type { PageData } from './$types';

	export let data: PageData;
	let username: string | null;
	UsernameStore.subscribe((v) => (username = v));
</script>

<div class="h-[100vh] flex flex-col items-center justify-between">
	<div class="h-full flex flex-col items-center justify-center gap-4">
		<h1 class="text-4xl mb-4">It is da BB room</h1>
		{#if inou(data.session)}
			<Login supabase={data.supabase} />
		{:else}
			<a href="/view-items" class="underline decoration-solid">View items</a>
			<a href="/create-transaction" class="underline decoration-solid">Create transaction</a>
		{/if}
	</div>
	{#if ninou(username)}
		<div class="mb-4">Logged in as "{username}"</div>
	{/if}
</div>
