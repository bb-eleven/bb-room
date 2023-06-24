<script lang="ts">
	import CollapsibleItem from '$lib/components/CollapsibleItem.svelte';
	import Title from '$lib/components/Title.svelte';
	import SearchButton from '$lib/components/buttons/SearchButton.svelte';
	import { SelectionButtonType } from '$lib/components/buttons/selection-button-type';
	import Input from '$lib/components/inputs/Input.svelte';
	import MultiSelect from '$lib/components/inputs/selects/MultiSelect.svelte';
	import SingleSelect from '$lib/components/inputs/selects/SingleSelect.svelte';
	import type { Database } from '$lib/database.types';
	import { cubicOut } from 'svelte/easing';
	import { slide } from 'svelte/transition';

	type ItemViewRow = Database['public']['Views']['item_view']['Row'];
	const itemViews: ItemViewRow[] = new Array(300)
		.fill({
			id: 1,
			category_ids: [1, 2, 3],
			category_names: ['1', '2', '3'],
			location_codes: ['L1', 'tbc'],
			location_quantities: [30, 0],
			name: 'hello hello hello hello hello hello hello hello hello hello hello hello hello hello hello',
			variant_name: null,
		})
		.map((itemView, i) => ({ ...itemView, name: [itemView.name, i].join(' ') }));
	let multiSelectedLocations: any[] = [];
	let showSearchInputs = false;

	// TODO: update Supabase types
	const getLocationOptionDisplay = (selected: ItemViewRow) => selected?.name ?? '';
	const getLocationInputDisplay = (selected?: ItemViewRow) => selected?.name ?? 'Select';
	const getLocationInputDisplayM = (selected: ItemViewRow[]) =>
		selected.length === 0 ? 'Select' : selected.map(({ name }) => name).join(', ');
</script>

<!-- TODO: remove negative margin, 100vh(?) -->
<div class="relative h-[100vh] bg-off-100 p-3 mt-[-0.5rem]">
	<div class="relative flex items-end gap-2">
		<Title title="Inventory" />
		<SearchButton click={() => (showSearchInputs = !showSearchInputs)} />

		<!-- Search inputs -->
		{#if showSearchInputs}
			<div
				transition:slide={{ duration: 500, easing: cubicOut }}
				class="absolute z-50 top-16 rounded-2xl w-full p-3 space-y-4 bg-off-100 drop-shadow-2xl shadow-lg"
			>
				<Input label="Name" />
				<SingleSelect
					label="Locations"
					selected={null}
					getInputText={getLocationInputDisplay}
					getOptionText={getLocationOptionDisplay}
					options={itemViews}
				/>

				<MultiSelect
					label="Locations"
					bind:selected={multiSelectedLocations}
					getInputText={getLocationInputDisplayM}
					getOptionText={getLocationOptionDisplay}
					options={itemViews}
				/>
			</div>
		{/if}
	</div>

	<!-- Items -->
	<div class="mt-6 h-[80vh] overflow-y-scroll">
		{#each itemViews as itemView}
			<CollapsibleItem {itemView} selectionButtonType={SelectionButtonType.Check} class="mb-4" />
		{/each}
	</div>
</div>
