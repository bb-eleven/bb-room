<script lang="ts">
	import { slide } from 'svelte/transition';
	import { cubicOut } from 'svelte/easing';
	import CollapseButton from './buttons/CollapseButton.svelte';
	import type { Database } from '$lib/database.types';
	import SelectionButton from './buttons/SelectionButton.svelte';
	import type { SelectionButtonType } from './buttons/selection-button-type';
	import type { Nullable } from 'vitest';

	let collapsed = true; // Collapsed by default
	export let itemView: Database['public']['Views']['item_view']['Row'];
	export let selectionButtonType: Nullable<SelectionButtonType> = null;
</script>

<div class="bg-off-200 rounded-2xl {$$props.class}">
	<!-- Header -->
	<div
		class="px-4 py-3 bg-off-400 text-off-800 {collapsed
			? 'rounded-2xl'
			: 'rounded-t-2xl'} flex justify-between"
	>
		<span class="text-ellipsis whitespace-nowrap overflow-hidden">{itemView.name}</span>
		<div class="relative min-w-[6rem]">
			<!-- Button container -->
			<div class="absolute right-0 translate-y-1 flex flex-row gap-2">
				<CollapseButton click={() => (collapsed = !collapsed)} />
				<SelectionButton type={selectionButtonType} />
			</div>
		</div>
	</div>

	<!-- Body -->
	{#if !collapsed}
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
