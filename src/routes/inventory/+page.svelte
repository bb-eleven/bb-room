<script lang="ts">
	import CollapsibleItem from '$lib/components/CollapsibleItem.svelte';
	import Title from '$lib/components/Title.svelte';
	import SearchButton from '$lib/components/buttons/SearchButton.svelte';
	import { SelectionButtonType } from '$lib/components/buttons/selection-button-type';
	import type { Database } from '$lib/database.types';

	const itemViews: Database['public']['Views']['item_view']['Row'][] = new Array(300).fill({
		id: 1,
		category_ids: [1, 2, 3],
		category_names: ['1', '2', '3'],
		location_codes: ['L1', 'tbc'],
		location_quantities: [30, 0],
		name: 'hello',
		variant_name: null,
	});
</script>

<!-- TODO: remove negative margin, 100vh(?) -->
<div class="h-[100vh] bg-off-100 p-3 mt-[-0.5rem]">
	<div class="flex items-end gap-2">
		<Title title="Inventory" />
		<SearchButton />
	</div>

	<!-- Items -->
	<div class="mt-6 h-[80vh] overflow-y-scroll">
		{#each itemViews as itemView}
			<CollapsibleItem {itemView} selectionButtonType={SelectionButtonType.Check} class="mb-4" />
		{/each}
	</div>
</div>
