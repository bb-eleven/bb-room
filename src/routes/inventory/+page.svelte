<script lang="ts">
	import Title from '$lib/components/Title.svelte';
	import SearchButton from '$lib/components/buttons/SearchButton.svelte';
	import TextButton from '$lib/components/buttons/TextButton.svelte';
	import Input from '$lib/components/inputs/Input.svelte';
	import MultiSelect from '$lib/components/inputs/selects/MultiSelect.svelte';
	import { backIn, cubicOut } from 'svelte/easing';
	import { slide } from 'svelte/transition';
	import type { Category, ItemView, Location } from '$lib/database.types.short.js';
	import * as Mod from './mod.js';
	import { SelectionButtonType } from '$lib/components/buttons/selection-button-type.js';
	import CollapsibleItem from '$lib/components/CollapsibleItem.svelte';
	import { inou, ninou } from '$lib/utils.js';
	import { clickOutside } from '$lib/click-outside.js';
	import { defaultRotatingIconData } from '$lib/components/icons/rotating-icon.js';
	import CollapseButton from '$lib/components/buttons/CollapseButton.svelte';
	import { IconSvg } from '$lib/components/icons/icon-svg.js';
	import type { Nullable } from 'vitest';

	export let data;
	let itemViews: ItemView['Row'][] = [];
	let itemViewSelecteds: boolean[];

	// TODO: use map to keep track of
	let selectedItemViewIdOriginalIndexMap = new Map<number, number>();
	let searchName = '';
	let selectedCategories: Category['Row'][];
	let selectedLocations: Location['Row'][];
	let searchButtonRotatingIconData = defaultRotatingIconData();
	let collapseSelectedItemViewsTab = true;

	Mod.getItemViews(data.supabase).then((data) => {
		itemViews = data ?? [];
		itemViewSelecteds = new Array(itemViews.length).fill(false);
		selectedItemViewIdOriginalIndexMap = new Map<number, number>();
	});

	const search = async () => {
		itemViews = await Mod.filterItemViews(
			data.supabase,
			searchName,
			selectedCategories,
			selectedLocations,
		);
		searchButtonRotatingIconData.rotated = false;
		itemViewSelecteds = new Array(itemViews.length).fill(false);
		selectedItemViewIdOriginalIndexMap = new Map<number, number>();
	};

	const selectItemView = (id: Nullable<number>, i: number) => {
		if (inou(id)) {
			return;
		}

		if (selectedItemViewIdOriginalIndexMap.has(id)) {
			itemViewSelecteds[i] = false;
			selectedItemViewIdOriginalIndexMap.delete(id);

			if (selectedItemViewIdOriginalIndexMap.size === 0) {
				collapseSelectedItemViewsTab = true;
			}
		} else {
			itemViewSelecteds[i] = true;
			selectedItemViewIdOriginalIndexMap.set(id, i);
		}

		selectedItemViewIdOriginalIndexMap = selectedItemViewIdOriginalIndexMap;
	};

	const deselectItemView = (id: Nullable<number>) => {
		if (inou(id)) {
			return;
		}

		let oi = selectedItemViewIdOriginalIndexMap.get(id);
		if (inou(oi)) {
			return;
		}

		itemViewSelecteds[oi] = false;
		selectedItemViewIdOriginalIndexMap.delete(id);

		if (selectedItemViewIdOriginalIndexMap.size === 0) {
			collapseSelectedItemViewsTab = true;
		}

		itemViewSelecteds = itemViewSelecteds;
		selectedItemViewIdOriginalIndexMap = selectedItemViewIdOriginalIndexMap;
	};
</script>

<!-- TODO: remove negative margin, 100vh(?) -->
<div class="relative w-full h-[100vh] bg-off-100 p-3 mt-[-0.5rem]">
	<div class="relative flex items-end gap-2">
		<Title title="Inventory" />
		<SearchButton bind:rotatingIconData={searchButtonRotatingIconData} />

		<!-- Search inputs -->
		{#if searchButtonRotatingIconData.rotated}
			<div
				transition:slide={{ duration: 500, easing: cubicOut }}
				use:clickOutside={() => (searchButtonRotatingIconData.rotated = false)}
				class="absolute z-50 flex flex-col top-16 rounded-2xl w-full p-3 gap-4 bg-off-100 drop-shadow-2xl shadow-lg"
			>
				<Input label="Name" bind:value={searchName} />

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
	<div class="bg-brown-100 px-2 py-1 mt-4 w-fit rounded-lg justify-self-end">
		<span class="text-sm text-brown-500">showing {itemViews.length} results</span>
	</div>

	<!-- Items -->
	{#if ninou(itemViews)}
		<div class="mt-4 h-[80vh] overflow-y-scroll">
			{#each itemViews as itemView, i}
				<CollapsibleItem
					bind:itemView={itemViews[i]}
					selectionButtonType={SelectionButtonType.Check}
					bind:selected={itemViewSelecteds[i]}
					select={() => selectItemView(itemView.id, i)}
					class="mb-4"
				/>
			{/each}
		</div>
	{/if}

	{#if selectedItemViewIdOriginalIndexMap.size > 0}
		<!-- TODO: refactor to its own component -->
		<div
			in:slide={{ duration: 200, easing: cubicOut }}
			out:slide={{ duration: 300, easing: cubicOut }}
			class="absolute left-0 bottom-0 right-0 rounded-t-2xl w-[calc(100%-1.5rem)] mx-3 p-3 gap-4 bg-off-100 drop-shadow-2xl shadow-[0px_10px_40px_rgba(0,0,0,0.1)]"
		>
			<div class="absolute right-6 -translate-y-3/4">
				<CollapseButton
					click={() => (collapseSelectedItemViewsTab = !collapseSelectedItemViewsTab)}
					icon={IconSvg.ChevronUp}
					class="bg-yellow-400 fill-yellow-600 animate-slide-up"
				/>
			</div>

			<div class="flex gap-2 items-center">
				<div class="px-3 py-2 bg-brown-100 text-brown-500 rounded-xl">
					{selectedItemViewIdOriginalIndexMap.size}
					{selectedItemViewIdOriginalIndexMap.size === 1 ? 'item' : 'items'} selected
				</div>

				<TextButton text="Next" />
			</div>

			{#if !collapseSelectedItemViewsTab}
				<div
					in:slide={{ duration: 300, easing: backIn }}
					out:slide={{ duration: 400, easing: cubicOut }}
					class="max-h-[50vh] mt-4 overflow-y-scroll"
				>
					{#each [...selectedItemViewIdOriginalIndexMap.values()].map((oi) => itemViews[oi]) as selectedItemView}
						<div in:slide={{ duration: 300 }} out:slide={{ duration: 100 }}>
							<CollapsibleItem
								itemView={selectedItemView}
								selectionButtonType={SelectionButtonType.X}
								select={() => deselectItemView(selectedItemView.id)}
								class="mb-4"
							/>
						</div>
					{/each}
				</div>
			{/if}
		</div>
	{/if}
</div>
