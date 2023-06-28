<script lang="ts">
	import Title from '$lib/components/Title.svelte';
	import SearchButton from '$lib/components/buttons/SearchButton.svelte';
	import TextButton from '$lib/components/buttons/TextButton.svelte';
	import Input from '$lib/components/inputs/Input.svelte';
	import MultiSelect from '$lib/components/inputs/selects/MultiSelect.svelte';
	import { cubicOut } from 'svelte/easing';
	import { slide } from 'svelte/transition';
	import type { Category, ItemView, Location } from '$lib/database.types.short.js';
	import * as Mod from './mod.js';
	import { SelectionButtonType } from '$lib/components/buttons/selection-button-type.js';
	import CollapsibleItem from '$lib/components/CollapsibleItem.svelte';
	import { ninou } from '$lib/utils.js';

	export let data;

	let itemViews: ItemView['Row'][];
	let selectedCategories: Category['Row'][];
	let selectedLocations: Location['Row'][];
	let showSearchInputs = false;

	Mod.getItemViews(data.supabase).then((data) => (itemViews = data ?? []));

	const search = () => {};
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
				class="absolute z-50 flex flex-col top-16 rounded-2xl w-full p-3 gap-4 bg-off-100 drop-shadow-2xl shadow-lg"
			>
				<Input label="Name" />

				<MultiSelect
					label="Categories"
					bind:selected={selectedCategories}
					getInputText={Mod.getCategoriesInputDisplay}
					getOptionText={Mod.getCategoriesOptionDisplay}
					options={data.categories}
				/>

				<MultiSelect
					label="Locations"
					bind:selected={selectedLocations}
					getInputText={Mod.getLocationsInputDisplay}
					getOptionText={Mod.getLocationsOptionDisplay}
					options={data.locations}
				/>

				<div class="flex justify-end mt-4">
					<TextButton text="Search" click={search} />
				</div>
			</div>
		{/if}
	</div>

	<!-- Items -->
	{#if ninou(itemViews)}
		<div class="mt-6 h-[80vh] overflow-y-scroll">
			{#each itemViews as itemView}
				<CollapsibleItem {itemView} selectionButtonType={SelectionButtonType.Check} class="mb-4" />
			{/each}
		</div>
	{/if}
</div>
