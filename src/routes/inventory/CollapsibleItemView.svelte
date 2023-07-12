<script lang="ts">
	import { slide } from 'svelte/transition';
	import { cubicOut } from 'svelte/easing';
	import type { SelectionButtonType } from '../../lib/components/buttons/selection-button-type';
	import type { Nullable } from 'vitest';
	import type { ItemView } from '$lib/database.types.short';
	import { ninou } from '$lib/utils';
	import CollapsibleView from '../../lib/components/CollapsibleView.svelte';

	export let itemView: ItemView['Row'];
	export let selectionButtonType: Nullable<SelectionButtonType> = null;
	export let selected = false;
	export let select: (selected: boolean) => void = (selected) => {};
</script>

<CollapsibleView bind:selected bind:selectionButtonType {select} class={$$props.class}>
	<svelte:fragment slot="title">
		<span class="text-off-800">{itemView.name}</span>
		{#if ninou(itemView.variant_name)}
			<span class="text-brown-600 ml-2">[{itemView.variant_name}]</span>
		{/if}
	</svelte:fragment>

	<svelte:fragment slot="body">
		<div class="p-4">
			<span class="text-off-600">Categories: </span>
			<span class="text-off-700">{itemView.category_names?.join(', ')}</span>
		</div>
	</svelte:fragment>

	<svelte:fragment slot="collapsible-body">
		<div
			transition:slide={{ duration: 500, easing: cubicOut }}
			class="p-4 pt-0 flex flex-col gap-4"
		>
			<div>
				<span class="text-off-600">Total quantity: </span>
				<span class="text-off-700">{itemView.location_quantities?.reduce((a, b) => a + b)}</span>
			</div>
			<div>
				<span class="text-off-600">Locations: </span>
				<span class="text-off-700">{itemView.location_codes?.join(', ')}</span>
			</div>
		</div>
	</svelte:fragment>
</CollapsibleView>
