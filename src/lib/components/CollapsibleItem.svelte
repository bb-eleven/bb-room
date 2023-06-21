<script lang="ts">
	import { slide } from 'svelte/transition';
	import { cubicOut } from 'svelte/easing';
	import ExpandButton from './buttons/ExpandButton.svelte';
	import { IconSvg } from './icon/icon-svg';
	import type { Database } from '$lib/database.types';

	let expanded = true; // Expanded by default
	export let itemView: Database['public']['Views']['item_view']['Row'];
</script>

<div class="bg-off-200 rounded-2xl">
	<!-- Header -->
	<div
		class="px-4 py-3 bg-off-400 text-off-800 {expanded
			? 'rounded-t-2xl'
			: 'rounded-2xl'} flex justify-between"
	>
		<span>{itemView.name}</span>
		<div class="relative">
			<ExpandButton
				icon={IconSvg.ChevronUp}
				click={() => (expanded = !expanded)}
				class="w-10 absolute right-0 translate-y-1/4 bg-brown-300 fill-brown-100"
			/>
		</div>
	</div>

	<!-- Body -->
	{#if expanded}
		<div
			transition:slide={{ duration: 500, easing: cubicOut }}
			class="px-4 py-4 flex flex-col gap-4"
		>
			<div>
				<span class="text-off-600">Total quantity: </span>
				<span class="text-off-700">{itemView.location_quantities?.reduce((a, b) => a + b)}</span>
			</div>
			<div>
				<span class="text-off-600">Locations: </span>
				<span class="text-off-700">{itemView.location_codes?.join(', ')}</span>
			</div>
			<div>
				<span class="text-off-600">Categories: </span>
				<span class="text-off-700">{itemView.category_names?.join(', ')}</span>
			</div>
		</div>
	{/if}
</div>
